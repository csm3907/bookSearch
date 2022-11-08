//
//  HTTPTask.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import Foundation

public typealias Parameters = [String:Any]

public enum HTTPTask{
    case request
    
    case requestParameters(urlParameters: Parameters?)
    
    case requestParametersAndHeaders(urlParameters: Parameters?, additionHeaders: HTTPHeaders?)
    
    case requestJson(Encodable)
    
    case requestJsonAndHeaders(Encodable, additionalHeaders: HTTPHeaders?)
}

