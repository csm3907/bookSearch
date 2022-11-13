//
//  BookSearchTestProvider.swift
//  bookSearchTests
//
//  Created by USER on 2022/11/13.
//

import XCTest
@testable import bookSearch

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    
}

class BookSearchApiTestProvider {
    
    let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchSearchBook(completion: @escaping (Result<BookSearch, HTTPSStatusCode>) -> Void) {
        let request = URLRequest(url: BookSearchTestAPI.getBookSearchList.url)
        
        let task: URLSessionDataTask = session
            .dataTask(with: request) { data, urlResponse, error in
                guard let response = urlResponse as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                          let response = urlResponse as? HTTPURLResponse
                          completion(.failure(HTTPSStatusCode(rawValue: response?.statusCode ?? 0) ?? .defaultError))
                          return
                      }
                
                if let data = data,
                   let searchResponse = try? JSONDecoder().decode(BookSearch.self, from: data) {
                    completion(.success(searchResponse))
                    return
                }
                completion(.failure(HTTPSStatusCode.defaultError))
            }
        
        task.resume()
    }
    
    func fetchBookInfo(completion: @escaping (Result<BookInfo, HTTPSStatusCode>) -> Void) {
        let request = URLRequest(url: BookSearchTestAPI.getBookInfo.url)
        
        let task: URLSessionDataTask = session
            .dataTask(with: request) { data, urlResponse, error in
                guard let response = urlResponse as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                          let response = urlResponse as? HTTPURLResponse
                          completion(.failure(HTTPSStatusCode(rawValue: response?.statusCode ?? 0) ?? .defaultError))
                          return
                      }
                
                if let data = data,
                   let searchResponse = try? JSONDecoder().decode(BookInfo.self, from: data) {
                    completion(.success(searchResponse))
                    return
                }
                completion(.failure(HTTPSStatusCode.defaultError))
            }
        
        task.resume()
    }
    
        
}

