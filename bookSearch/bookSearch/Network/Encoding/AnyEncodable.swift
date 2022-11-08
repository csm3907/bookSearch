//
//  AnyEncodable.swift
//  bookSearch
//
//  Created by USER on 2022/11/08.
//

import Foundation

class AnyEncodable: Encodable {

    private let encodable: Encodable

    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
