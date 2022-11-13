//
//  MockUrlSessionDataTask.swift
//  bookSearchTests
//
//  Created by USER on 2022/11/13.
//

import XCTest

class URLSessionDataTaskMock: URLSessionDataTask {
    private let resumeDidCall: () -> Void
    init(closure: @escaping () -> Void) {
        self.resumeDidCall = closure
    }
    override func resume() {
        resumeDidCall()
    }
}

class MockURLSession: URLSessionProtocol {
    
    var makeRequestFail = false
    init(makeRequestFail: Bool = false) {
        self.makeRequestFail = makeRequestFail
    }
    
    var sessionDataTask: URLSessionDataTaskMock?
    
    // dataTask 를 구현합니다.
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let sessionDataTask = URLSessionDataTaskMock.init {
            
            // 실패시 callback 으로 넘겨줄 response
            let failureResponse = HTTPURLResponse(url: BookSearchTestAPI.getBookInfo.url,
                                                  statusCode: 404,
                                                  httpVersion: "2",
                                                  headerFields: nil)
            
            if self.makeRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                switch request.url {
                case BookSearchTestAPI.getBookSearchList.url:
                    // 성공시 callback 으로 넘겨줄 response
                    let successResponse = HTTPURLResponse(url: BookSearchTestAPI.getBookSearchList.url,
                                                          statusCode: 200,
                                                          httpVersion: "2",
                                                          headerFields: nil)
                    
                    completionHandler(BookSearchTestAPI.sampleSearchData, successResponse, nil)
                case BookSearchTestAPI.getBookInfo.url:
                    // 성공시 callback 으로 넘겨줄 response
                    let successResponse = HTTPURLResponse(url: BookSearchTestAPI.getBookInfo.url,
                                                          statusCode: 200,
                                                          httpVersion: "2",
                                                          headerFields: nil)
                    
                    
                    completionHandler(BookSearchTestAPI.sampleInfoData, successResponse, nil)
                default:
                    completionHandler(nil, failureResponse, nil)
                }
            }
        }
        
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}

