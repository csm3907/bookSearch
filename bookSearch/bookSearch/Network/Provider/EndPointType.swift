//
//  EndPointType.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import Foundation

protocol EndPointType {
    associatedtype T = Encodable
    
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var task: HTTPTask { get }
}

public typealias HTTPHeaders = [String:String]

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}
