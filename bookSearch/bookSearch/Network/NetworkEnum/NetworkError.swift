//
//  NetworkError.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import Foundation

enum HTTPSStatusCode: Int, Error {
    case success = 200
    case badRequest = 400
    case unAuthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500
    case serverError2 = 503
    case defaultError
}

enum NetworkResponse:String {
    case success
    case badRequest = "Bad request"
    case unAuthorized = "You need to be authenticated first."
    case forbidden = "The url forbidden"
    case notFound = "The url notFound"
    case serverError = "UnSplash Server is not working"
    case serverError2 = "UnSplash Server is not delaying"
    case noData = "Data is empty"
}

public enum NetworkError: String, Error {
    case parameterIsNil = "Parameter is nil"
    case encodingFailed = "Parameter Encoding fails"
    case decodingFailed = "Decoding fails"
    case missingURL = "URL is nil"
    case defaultCase = "Check Network Status"
}

