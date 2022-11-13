//
//  TestCases.swift
//  bookSearchTests
//
//  Created by USER on 2022/11/13.
//

import XCTest

enum BookSearchTestAPI {
    
    case getBookSearchList
    case getBookInfo
    
    var path: String {
        switch self {
        case .getBookSearchList:
            return APIConstant.SEARCH_BASE_PATH + "/Swift"
        case .getBookInfo:
            return APIConstant.BOOK_INFO_BASE_PATH + "/9781617294136"
        }
    }
    var url: URL {
        URL(string: BookSearchTestAPI.baseURL + self.path)!
    }
    
    static let baseURL = APIConstant.IT_BOOK_DOMAIN
    
    static var sampleSearchData: Data {
        Data(
            """
               {
                   "total": "48",
                   "page": "1",
                   "books": [
                       {
                           "title": "Practical MongoDB",
                           "subtitle": "Architecting, Developing, and Administering MongoDB",
                           "isbn13": "9781484206485",
                           "price": "$32.04",
                           "image": "https://itbook.store/img/books/9781484206485.png",
                           "url": "https://itbook.store/books/9781484206485"
                       }
                   ]
               }
            """.utf8
        )
    }
    
    static var sampleInfoData: Data {
        Data(
            """
               {
                   "error": "0",
                   "title": "Securing DevOps",
                   "subtitle": "Security in the Cloud",
                   "authors": "Julien Vehent",
                   "publisher": "Manning",
                   "isbn10": "1617294136",
                   "isbn13": "9781617294136",
                   "pages": "384",
                   "year": "2018",
                   "rating": "5",
                   "desc": "An application running in the cloud can benefit from incredible efficiencies, but they come with unique security threats too. A DevOps team's highest priority is understanding those risks and hardening the system against them.Securing DevOps teaches you the essential techniques to secure your cloud ...",
                   "price": "$26.98",
                   "image": "https://itbook.store/img/books/9781617294136.png",
                   "url": "https://itbook.store/books/9781617294136",
                   "pdf": {
                             "Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf",
                             "Chapter 5": "https://itbook.store/files/9781617294136/chapter5.pdf"
                          }
               }
            """.utf8
        )
    }
    
}

