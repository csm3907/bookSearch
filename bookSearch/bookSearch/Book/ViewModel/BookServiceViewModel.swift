//
//  BookServiceViewModel.swift
//  bookSearch
//
//  Created by USER on 2022/11/09.
//

import Foundation

protocol BookServiceViewModelInput {
    func getBookSearchList(bookName: String, page: Int)
    func getBookInfo(bookId: String)
}

protocol BookServiceViewModelOutput {
    var errorMsg: Dynamic<String> { get }
    var bookList: Dynamic<[Book]?> { get }
    var bookInfo: Dynamic<BookInfo?> { get }
}

protocol BookServiceViewModelType {
    var input: BookServiceViewModelInput { get }
    var output: BookServiceViewModelOutput { get }
}

class BookServiceViewModel: BookServiceViewModelInput, BookServiceViewModelOutput, BookServiceViewModelType {
    
    // MARK: - TYPE
    
    var input: BookServiceViewModelInput { self }
    var output: BookServiceViewModelOutput { self }
    
    // MARK: - Output
    
    var errorMsg: Dynamic<String> = .init("")
    var bookList: Dynamic<[Book]?> = .init([])
    var bookInfo: Dynamic<BookInfo?> = .init(nil)
    
    // MARK: - Private variable
    
    private let router = Router<BookSearchAPI>()
    
    // MARK: - Input
    
    func getBookSearchList(bookName: String, page: Int = 0) {
        router.request(.getBookSearchList(query: bookName, page: page), Type: BookSearch.self) { [weak self] response, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMsg.value = error
            } else {
                if let bookList = response {
                    let books = bookList.books
                    if books?.count == 0 {
                        self.errorMsg.value = "검색 결과가 없습니다."
                    }
                    self.bookList.value = books
                }
            }
        }
    }
    
    func getBookInfo(bookId: String) { //"9781617294136"
        router.request(.getBookDetailInfo(bookId: bookId), Type: BookInfo.self) { [weak self] response, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMsg.value = error
            } else {
                if let bookInfo = response {
                    self.bookInfo.value = bookInfo
                }
            }
        }
    }
    
    deinit {
        self.bookList.disposeAll()
        self.errorMsg.disposeAll()
        self.bookInfo.disposeAll()
    }
}
