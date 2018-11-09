//
//  ImageCache.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import UIKit


enum CacheCleanReason {
    case lowMemory
    case appClosed
}


protocol ImageCache {
    func prepare()
    func image(forId id: Int, completion: ((UIImage?)->Void)?)
    func saveImage(_ image: UIImage, for id: Int)
    func clear(reason: CacheCleanReason)
}


class InMemoryImageCache: ImageCache {
    
    private let cache = NSCache<NSNumber, UIImage>()
    private let lock = DispatchQueue(label: "lockQueue")
    
    func prepare() {
    }
    
    func image(forId id: Int, completion: ((UIImage?)->Void)?) {
        lock.async {
            let image = self.cache.object(forKey: NSNumber(value: id))
            completion?(image)
        }
    }
    
    func saveImage(_ image: UIImage, for id: Int) {
        lock.async {
            self.cache.setObject(image, forKey: NSNumber(value: id))
        }
    }
    
    func clear(reason: CacheCleanReason) {
        lock.async {
            self.cache.removeAllObjects()
        }
    }
}


class FileImageCache: ImageCache {
    
    private var imagesDirectory: URL!
    
    func prepare() {
        let fileManager = FileManager.default
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).last!
        imagesDirectory = cachesDirectory.appendingPathComponent("images", isDirectory: true)
        try? fileManager.createDirectory(at: imagesDirectory, withIntermediateDirectories: false, attributes: nil)
    }
    
    func image(forId id: Int, completion: ((UIImage?)->Void)?) {
        DispatchQueue.global(qos: .background).async {
            let imagePath = self.imagesDirectory.appendingPathComponent(String(id), isDirectory: false)
            if let data = try? Data(contentsOf: imagePath) {
                let image = UIImage(data: data)
                completion?(image)
            }
            else {
                completion?(nil)
            }
        }
    }
    
    func saveImage(_ image: UIImage, for id: Int) {
        DispatchQueue.global(qos: .background).async {
            let imagePath = self.imagesDirectory.appendingPathComponent(String(id), isDirectory: false)
            if let jpgData = image.jpegData(compressionQuality: 100) {
                try? jpgData.write(to: imagePath)
            }
            else if let pngData = image.pngData() {
                try? pngData.write(to: imagePath)
            }
        }
    }
    
    func clear(reason: CacheCleanReason) {
        if reason == .appClosed {
            DispatchQueue.global(qos: .background).async {
                if let cacheUrls = try? FileManager.default.contentsOfDirectory(at: self.imagesDirectory,
                                                                                includingPropertiesForKeys: nil,
                                                                                options: .skipsHiddenFiles) {
                    for fileUrl in cacheUrls {
                        try? FileManager.default.removeItem(at: fileUrl)
                    }
                }
            }
        }
    }
}


class CombinedImageCache: ImageCache {
    
    private let memory: ImageCache = InMemoryImageCache()
    private let disk: ImageCache = FileImageCache()
    
    func prepare() {
        memory.prepare()
        disk.prepare()
    }
    
    func image(forId id: Int, completion: ((UIImage?) -> Void)?) {
        memory.image(forId: id, completion: { [weak self] image in
            if let image = image {
                debugPrint("Image from memory cache")
                completion?(image)
            }
            else {
                debugPrint("Ask file cache")
                self?.disk.image(forId: id, completion: completion)
            }
        })
    }
    
    func saveImage(_ image: UIImage, for id: Int) {
        memory.saveImage(image, for: id)
        disk.saveImage(image, for: id)
    }
    
    func clear(reason: CacheCleanReason) {
        memory.clear(reason: reason)
        disk.clear(reason: reason)
    }
}
