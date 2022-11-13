//
//  ImageCache.swift
//  bookSearch
//
//  Created by USER on 2022/11/13.
//

import UIKit

public protocol ImageCacheProtocol: AnyObject {
    func image(for url: URL) -> UIImage?
    func insertImage(_ image: UIImage?, for url: URL)
    func removeImage(for url: URL)
    func removeAllImages()
}

public enum SaveType: String {
    case fileManager = "file"
    case memory = "memory"
}

public final class ImageCache: ImageCacheProtocol {
    static let instance: ImageCache = ImageCache(config: Configuration(countLimit: 100, memoryLimit: 1024 * 1024 * 100, saveType: .fileManager))
    
    struct Configuration {
        static let basic = Configuration(countLimit: 100, memoryLimit: 1024 * 1024 * 100, saveType: .fileManager)
        let countLimit: Int
        let memoryLimit: Int
        let saveType: SaveType
    }
    
    // Thread-safe 한 NSCache -> race condition 따로 고려 필요 없음
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = configuration.countLimit
        return cache
    }()
    
    // Thread-safe 한 NSCache -> race condition 따로 고려 필요 없음
    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = configuration.memoryLimit
        return cache
    }()
    
    private let fileManager: FileManager = FileManager.default
    
    private let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    
    private lazy var filePath: URL? = {
        guard let path = path else { return nil }
        let url = URL(fileURLWithPath: path).appendingPathComponent("Book")
        return url
    }()
    
    private let configuration: Configuration
    private let semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)

    init(config: Configuration = Configuration.basic) {
        self.configuration = config
    }
    
}

public extension ImageCache {
    func image(for url: URL) -> UIImage? {
        switch configuration.saveType {
        case .fileManager:
            semaphore.wait()
            
            var result: UIImage? = nil
            guard var filePath = filePath else { return nil }
            filePath.appendPathComponent(url.lastPathComponent)
            if fileManager.fileExists(atPath: filePath.path) {
                guard let imageData = try? Data(contentsOf: filePath) else {
                    return nil
                }
                            
                guard let image = UIImage(data: imageData) else {
                    return nil
                }
                result = image.decodedImage()
            }
            
            semaphore.signal()
            return result
        case .memory:
            if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
                return decodedImage
            }
            
            if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
                let decodedImage = image.decodedImage()
                decodedImageCache.setObject(
                    image as AnyObject,
                    forKey: url as AnyObject,
                    cost: decodedImage.diskSize
                )
                return decodedImage
            }
        }
        return nil
    }

    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        let decompressedImage = image.decodedImage()
        
        switch configuration.saveType {
        case .fileManager:
            semaphore.wait()
            
            guard var filePath = self.filePath else { return }
            if !self.fileManager.fileExists(atPath: filePath.path) {
                do {
                    try self.fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Couldn't create document directory")
                }
            }
            
            filePath.appendPathComponent(url.lastPathComponent)
            self.fileManager.createFile(atPath: filePath.path,
                                   contents: decompressedImage.jpegData(compressionQuality: 0.4),
                                   attributes: nil)
            semaphore.signal()
            
        case .memory:
            imageCache.setObject(decompressedImage, forKey: url as AnyObject, cost: 1)
            decodedImageCache.setObject(
                image as AnyObject,
                forKey: url as AnyObject,
                cost: decompressedImage.diskSize
            )
        }
        
    }
}

public extension ImageCache {
    func removeImage(for url: URL) {
        switch configuration.saveType {
        case .fileManager:
            semaphore.wait()
            
            guard var filePath = self.filePath else { return }
            filePath.appendPathComponent(url.lastPathComponent)
            do {
                try self.fileManager.removeItem(atPath: filePath.path)
            } catch {
                print("file remove failed")
            }
            
            semaphore.signal()
            
        case .memory:
            imageCache.removeObject(forKey: url as AnyObject)
            decodedImageCache.removeObject(forKey: url as AnyObject)
        }
    }

    func removeAllImages() {
        switch configuration.saveType {
        case .fileManager:
            semaphore.wait()
            
            guard let filePath = self.filePath else { return }
            do {
                try self.fileManager.removeItem(atPath: filePath.path) // Directory 삭제
            } catch {
                print("file remove failed")
            }
            
            semaphore.signal()
            
        case .memory:
            imageCache.removeAllObjects()
            decodedImageCache.removeAllObjects()
        }
    }
}

fileprivate extension UIImage {
    func decodedImage() -> UIImage {
        guard let cgImage = cgImage else { return self }
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: cgImage.bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let decodedImage = context?.makeImage() else { return self }
        return UIImage(cgImage: decodedImage)
    }

    var diskSize: Int {
        guard let cgImage = cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}
