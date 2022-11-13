//
//  bookSearchTests.swift
//  bookSearchTests
//
//  Created by USER on 2022/11/08.
//

import XCTest
@testable import bookSearch

final class bookSearchTests: XCTestCase {
    
    var sut: BookSearchApiTestProvider!

    override func setUpWithError() throws {
        sut = .init()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_fetchSearchBookFromURL() {
        let expectation = XCTestExpectation()
        
        sut.fetchSearchBook { result in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success.books)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchSearchBook() {
        sut = .init(session: MockURLSession())
        let expectation = XCTestExpectation()
        
        sut.fetchSearchBook { result in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success.books)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchBookInfoFromURL() {
        let expectation = XCTestExpectation()
        
        sut.fetchBookInfo { result in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success.title)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchBookInfo() {
        sut = .init(session: MockURLSession())
        let expectation = XCTestExpectation()
        
        sut.fetchBookInfo { result in
            switch result {
            case .success(let success):
                XCTAssertNotNil(success.title)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_error404() {
        sut = .init(session: MockURLSession(makeRequestFail: true))
        let expectation = XCTestExpectation()
        
        sut.fetchSearchBook { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.rawValue, 404)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_SearchResultViewController() {
        testMemoryViewController {
            ViewController()
        }
    }
    
    func test_DetailViewController() {
        testMemoryViewController {
            DetailViewController(viewModel: BookServiceViewModel())
        }
    }
    
    func testMemoryViewController(of testedViewController: () -> UIViewController) {
        weak var weakReferenceViewController: UIViewController?
        
        let autoreleasepoolExpectation = expectation(description: "Autoreleasepool should drain")
        autoreleasepool {
            let rootViewController = UIViewController()
            
            // Make sure that the view is active and we can use it for presenting views.
            let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
            
            /// Present and dismiss the view after which the view controller should be released.
            rootViewController.present(testedViewController(), animated: false, completion: {
                weakReferenceViewController = rootViewController.presentedViewController
                XCTAssertNotNil(weakReferenceViewController)
                
                rootViewController.dismiss(animated: false, completion: {
                    autoreleasepoolExpectation.fulfill()
                })
            })
        }
        wait(for: [autoreleasepoolExpectation], timeout: 10.0)
        wait(for: weakReferenceViewController == nil, timeout: 3.0, description: "ViewController deallocate 실패")
    }
    
    func wait(for condition: @autoclosure @escaping () -> Bool, timeout: TimeInterval, description: String, file: StaticString = #file, line: UInt = #line) {
        let end = Date().addingTimeInterval(timeout)
        
        var value: Bool = false
        let closure: () -> Void = {
            value = condition()
        }
        
        while !value && 0 < end.timeIntervalSinceNow {
            if RunLoop.current.run(mode: RunLoop.Mode.default, before: Date(timeIntervalSinceNow: 0.002)) {
                Thread.sleep(forTimeInterval: 0.002)
            }
            closure()
        }
        
        closure()
        
        XCTAssertTrue(value, "Timed out waiting for condition to be true: \"\(description)\"", file: file, line: line)
    }
    
}
