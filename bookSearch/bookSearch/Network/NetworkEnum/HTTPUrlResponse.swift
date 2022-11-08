//
//  HTTPUrlResponse.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import Foundation

enum ResultString<String>{
    case success
    case failure(String)
}

extension HTTPURLResponse {
    
    func handleNetworkResponse() -> ResultString<String> {
        switch self.statusCode {
        case HTTPSStatusCode.success.rawValue: return .success
        case HTTPSStatusCode.badRequest.rawValue: return .failure(NetworkResponse.badRequest.rawValue)
        case HTTPSStatusCode.unAuthorized.rawValue: return .failure(NetworkResponse.unAuthorized.rawValue)
        case HTTPSStatusCode.forbidden.rawValue: return .failure(NetworkResponse.forbidden.rawValue)
        case HTTPSStatusCode.notFound.rawValue: return .failure(NetworkResponse.notFound.rawValue)
        case HTTPSStatusCode.serverError.rawValue: return .failure(NetworkResponse.serverError.rawValue)
        case HTTPSStatusCode.serverError2.rawValue: return .failure(NetworkResponse.serverError2.rawValue)
        default: return .failure(NetworkError.defaultCase.rawValue)
        }
    }
    
}
