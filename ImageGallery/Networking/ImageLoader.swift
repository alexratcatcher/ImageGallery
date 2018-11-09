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


class ProtoImageLoader: ImageLoader {
    
    private let picturesApi: PicturesAPI
    
    init(picturesApi: PicturesAPI) {
        self.picturesApi = picturesApi
    }
    
    func loadPicture(request: ImageLoadingRequest) {
        let task = picturesApi.loadPicture(withId: request.imageId, completion: { image in
            DispatchQueue.main.async {
                request.onImageLoaded?(image)
            }
        })
        request.loadingTask = task
    }
}
