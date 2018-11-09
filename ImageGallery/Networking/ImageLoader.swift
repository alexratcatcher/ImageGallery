//
//  ImageLoader.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import UIKit


class ImageLoader {
    
    private let picturesApi: LoremPicsumAPI
    
    init(picturesApi: LoremPicsumAPI) {
        self.picturesApi = picturesApi
    }
    
    func loadPicture(withId id: Int, completion: ((UIImage?)->Void)?) -> URLSessionTask {
        return picturesApi.loadPicture(withId: id, completion: { image in
            DispatchQueue.main.async {
                completion?(image)
            }
        })
    }
}
