//
//  JSONParameterEncoder.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import Foundation

public struct JSONParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: Encodable) throws {
        do {
            let encodable = AnyEncodable(parameters)
            let jsonData = try JSONEncoder().encode(encodable)
            urlRequest.httpBody = jsonData
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
            
        } catch {
            throw NetworkError.encodingFailed
        }
        
    }
}

