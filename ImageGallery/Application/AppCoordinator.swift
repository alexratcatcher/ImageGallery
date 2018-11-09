//
//  AppCoordinator.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import UIKit


class AppCoordinator {
    
    let picturesApi: PicturesAPI
    let imageCache: ImageCache
    let imageLoader: ImageLoader
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        
        picturesApi = LoremPicsumAPI(session: URLSession.shared)
        
        imageCache = CombinedImageCache()
        imageCache.prepare()
        
        imageLoader = CachingImageLoader(picturesApi: picturesApi, cache: imageCache)
    }
    
    func start() {
        let mainVC = ImageGalleryViewController.instantiate()
        mainVC.title = "Images"
        
        let viewModel = ImageGalleryViewModel(picturesApi: picturesApi, imageLoader: imageLoader)
        mainVC.viewModel = viewModel
        
        window.rootViewController = mainVC
        
        window.makeKeyAndVisible()
    }
}
