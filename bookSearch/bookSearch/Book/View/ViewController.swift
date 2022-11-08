//
//  ViewController.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import UIKit

class ViewController: UIViewController {
    
    let router = Router<BookSearchAPI>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        getBookList()
        getBookInfo()
    }
    
    func getBookList() {
        router.request(.getBookSearchList(query: "Swift", page: 0), encodeType: BookSearch.self) { response, error in
            if let error = error {
                print(error)
            } else {
                if let response = response {
                    let bookList = response as? BookSearch
                    print(bookList)
                }
            }
        }
    }
    
    func getBookInfo() {
        router.request(.getBookDetailInfo(bookId: "9781617294136"), encodeType: BookInfo.self) { response, error in
            if let error = error {
                print(error)
            } else {
                if let response = response {
                    let bookList = response as? BookInfo
                    print(bookList)
                }
            }
        }
    }
    

}

