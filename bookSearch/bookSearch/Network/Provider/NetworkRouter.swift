//
//  NetworkRouter.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import Foundation

public typealias NetworkRouterCompletion = (_ response: Codable?, _ error: String?)->()

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    
    func request(_ route: EndPoint, encodeType: Codable.Type, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

