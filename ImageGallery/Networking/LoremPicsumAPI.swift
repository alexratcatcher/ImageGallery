//
//  LoremPicsumAPI.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import UIKit


struct PictureData: Codable {
    let id: Int?
    let author: String?
}


protocol PicturesAPI {
    func requestPicturesList(completion: @escaping ([PictureData], Error?) -> Void)
    func loadPicture(withId id: Int, resolution: Int, completion: ((UIImage?)->Void)?) -> URLSessionTask
}


class LoremPicsumAPI: PicturesAPI {
    
    let baseUrl = URL(string: "https://picsum.photos")!
    
    private let urlSession: URLSession
    
    init(session: URLSession) {
        self.urlSession = session
    }
    
    func requestPicturesList(completion: @escaping ([PictureData], Error?) -> Void) {
        let url = baseUrl.appendingPathComponent("list")
        
        let task = urlSession.dataTask(with: url, completionHandler: { data, response, error in
            var pictures = [PictureData]()
            
            if let error = error {
                completion(pictures, error)
                return
            }
            
            guard let data = data else {
                completion(pictures, NetworkingError.emptyResponse)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                pictures = try jsonDecoder.decode([PictureData].self, from: data)
                completion(pictures, nil)
            }
            catch {
                completion(pictures, error)
            }
        })
        task.resume()
    }
    
    func loadPicture(withId id: Int, resolution: Int, completion: ((UIImage?)->Void)?) -> URLSessionTask {
        let url = baseUrl.appendingPathComponent(String(resolution))
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "image", value: String(id))
        ]
        let requestUrl = urlComponents.url!
        
        let task = urlSession.dataTask(with: requestUrl, completionHandler: { data, response, error in
            guard error == nil, let data = data, !data.isEmpty else {
                completion?(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion?(image)
            }
        })
        task.resume()
        return task
    }
}
