//
//  AppCoordinator.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import UIKit


class AppCoordinator {
    
    let picturesApi: LoremPicsumAPI
    let imageLoader: ImageLoader
    
    let window: UIWindow
    let rootViewController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        
        picturesApi = LoremPicsumAPI(session: URLSession.shared)
        imageLoader = ImageLoader(picturesApi: picturesApi)
    }
    
    func start() {
        window.rootViewController = rootViewController
        
        let mainVC = ImageGalleryViewController.instantiate()
        mainVC.title = "Images"
        
        let viewModel = ImageGalleryViewModel(picturesApi: picturesApi, imageLoader: imageLoader)
        mainVC.viewModel = viewModel
        
        rootViewController.pushViewController(mainVC, animated: false)
        
        window.makeKeyAndVisible()
    }
}
