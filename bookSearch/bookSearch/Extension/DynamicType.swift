//
//  DynamicType.swift
//  bookSearch
//
//  Created by USER on 2022/11/09.
//

import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> ()

    var listeners: [Listener?] = []
    var value: T {
        didSet {
            for listener in listeners {
                listener?(value)
            }
        }
    }

    init(_ value: T) {
        self.value = value
    }

    // MARK : - Listener 등록 후 value 변경시 closure 실행

    func bind(_ listener: Listener?) {
        self.listeners.append(listener)
    }

    // MARK : - Listener 등록 후 closure 바로 실행

    func bindAndFire(_ listener: Listener?) {
        self.listeners.append(listener)
        listener?(value)
    }

    func disposed() {
        if !listeners.isEmpty {
            listeners.removeLast()
        }
    }
    
    func disposeAll() {
        listeners.removeAll()
    }
}
