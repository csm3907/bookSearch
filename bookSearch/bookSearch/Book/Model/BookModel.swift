//
//  BookModel.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import Foundation

// MARK: - BookSearch
struct BookSearch: Codable {
    let total, page: String?
    let books: [Book]?
}

// MARK: - Book
struct Book: Codable {
    let title, subtitle, isbn13, price: String?
    let image: String?
    let url: String?
}

// MARK: - BookInfo
struct BookInfo: Codable {
    let error, title, subtitle, authors: String?
    let publisher, isbn10, isbn13, pages: String?
    let year, rating, desc, price: String?
    let image: String?
    let url: String?
    let pdf: PDF?
}

// MARK: - PDF
struct PDF: Codable {
    let chapter2, chapter5: String?
    
    enum CodingKeys: String, CodingKey {
        case chapter2 = "Chapter 2",
             chapter5 = "Chapter 5"
    }
}
