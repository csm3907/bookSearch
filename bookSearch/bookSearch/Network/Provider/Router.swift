//
//  Router.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
    
    private var task: URLSessionTask?
    
    func request<T>(_ route: EndPoint, Type: T.Type, completion: @escaping (T?, String?) -> ()) where T : Decodable, T : Encodable {
        let session = URLSession.shared
        
        do {
            let request = try self.buildRequest(from: route)
            print("request url is :\(request.url)")
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    completion(nil, error?.localizedDescription)
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = response.handleNetworkResponse()
                    
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            let message = NetworkResponse.noData.rawValue
                            completion(nil, message)
                            return
                        }
                        let responseMessage = String(data: responseData, encoding: .utf8)
                        print(responseMessage ?? "??")
                        
                        do {
                            let json = try JSONDecoder().decode(T.self, from: responseData)
                            
                            completion(json, nil)
                        } catch {
                            completion(nil, "decode error")
                        }
                        
                    case .failure(let errorStr):
                        completion(nil, errorStr)
                    }
                }
            })
        } catch {
            completion(nil, "url data task error")
        }
        
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20.0)
        
        request.httpMethod = route.method.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let urlParameters):
                try self.configureParameters(urlParameters: urlParameters, request: &request)
                
            case .requestParametersAndHeaders(let urlParameters, let additionHeaders):
                self.addHeaders(additionHeaders, request: &request)
                try self.configureParameters(urlParameters: urlParameters, request: &request)
                
            case .requestJson(let jsonParameters):
                try self.configureJsonParameters(jsonParameters: jsonParameters, request: &request)
                
            case .requestJsonAndHeaders(let jsonParameters, let additionHeaders):
                self.addHeaders(additionHeaders, request: &request)
                try self.configureJsonParameters(jsonParameters: jsonParameters, request: &request)
            }
            
            return request
        } catch {
            throw NetworkError.encodingFailed
        }
    }
    
    func configureJsonParameters(jsonParameters: Encodable?, request: inout URLRequest) throws {
        do {
            if let jsonParameters = jsonParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: jsonParameters)
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
    
    func configureParameters(urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
            
        } catch {
            throw NetworkError.encodingFailed
        }
        
    }
    
    func addHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}

