//
//  UIImageVIew+Extension.swift
//  bookSearch
//
//  Created by USER on 2022/11/09.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        if let cachedImage = ImageCache.instance.image(for: url) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    ImageCache.instance.insertImage(image, for: url)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
    
}
