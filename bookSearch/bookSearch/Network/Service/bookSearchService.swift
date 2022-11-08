//
//  bookSearchService.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import Foundation

enum BookSearchAPI {
    case getBookSearchList(query: String, page: Int)
    case getBookDetailInfo(bookId: String)
}

extension BookSearchAPI: EndPointType {
    var baseURL: URL {
        switch self {
        case .getBookDetailInfo, .getBookSearchList:
            guard let url = URL(string: APIConstant.IT_BOOK_DOMAIN) else { fatalError("URL Missing") }
            return url
        }
    }
    
    var path: String {
        switch self {
        case .getBookSearchList(let query, let page):
            return APIConstant.SEARCH_BASE_PATH + "/\(query)" + "/\(page)"
            
        case .getBookDetailInfo(let bookID):
            return APIConstant.BOOK_INFO_BASE_PATH + "/\(bookID)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getBookDetailInfo, .getBookSearchList:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        return [
            "X-Ratelimit-Limit": "1000",
            "X-Ratelimit-Remaining": "999"
        ]
    }
    
    var task: HTTPTask {
        switch self {
        case .getBookSearchList:
            return .request
            
        case .getBookDetailInfo:
            return .request
        }
    }
    
    
}
