//
//  ImageLoader.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import UIKit


class ImageLoadingRequest {
    
    let imageId: Int
    var onImageLoaded: ((UIImage?)->Void)?
    
    fileprivate(set) var loadingTask: URLSessionTask?
    
    init(imageId: Int) {
        self.imageId = imageId
    }
    
    func cancel() {
        self.loadingTask?.cancel()
        self.loadingTask = nil
        
        self.onImageLoaded = nil
    }
}


protocol ImageLoader {
    func loadPicture(request: ImageLoadingRequest)
}


class CachingImageLoader: ImageLoader {
    
    private let picturesApi: PicturesAPI
    private let cache: ImageCache
    
    init(picturesApi: PicturesAPI, cache: ImageCache) {
        self.picturesApi = picturesApi
        self.cache = cache
    }
    
    func loadPicture(request: ImageLoadingRequest) {
        cache.image(forId: request.imageId, completion: { [weak self] image in
            if let image = image {
                DispatchQueue.main.async {
                    debugPrint("Image from cache")
                    request.onImageLoaded?(image)
                }
            }
            else {
                let task = self?.picturesApi.loadPicture(withId: request.imageId, completion: { [weak self] image in
                    if let image = image {
                        self?.cache.saveImage(image, for: request.imageId)
                    }
                    DispatchQueue.main.async {
                        debugPrint("Image from network")
                        request.onImageLoaded?(image)
                    }
                })
                request.loadingTask = task
            }
        })
    }
}
