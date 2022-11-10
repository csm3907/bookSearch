//
//  NetworkRouter.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import Foundation

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    
    func request<T:Codable>(_ route: EndPoint, Type: T.Type, completion: @escaping (_ response: T?, _ error: String?)->())
    func cancel()
}

