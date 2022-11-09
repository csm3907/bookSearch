//
//  UITableView+Extension.swift
//  bookSearch
//
//  Created by USER on 2022/11/09.
//

import UIKit

extension UITableView {
    func insertRows(_ pCnt: Int, _ nCnt: Int, _ section: Int = 0) {
        self.performBatchUpdates {
            self.insertRows(at: (pCnt..<nCnt).map{ IndexPath(item: $0, section: section)}, with: .bottom)
        }
    }
}
