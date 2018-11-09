//
//  ImageGalleryViewModel.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import Foundation


struct ImageCellViewModel {
    let imageId: Int?
    let authorName: String?
    let loadPicture: (ImageLoadingRequest)->Void
}


struct ImageGalleryRowViewModel {
    let cells: [ImageCellViewModel]
}


enum ImageGalleryViewState {
    case askForCount
    case loading
    case empty
    case pictures
    case error(Error)
}


class ImageGalleryViewModel {
    
    private let picturesApi: PicturesAPI
    private let imageLoader: ImageLoader
    
    
    // Output
    var data = [ImageGalleryRowViewModel]()
    var onViewStateChanged: ((ImageGalleryViewState)->Void)?
    
    // Input
    var requiredPicturesCount: Int = 0 {
        didSet {
            loadPicturesList(maxCount: requiredPicturesCount)
        }
    }
    
    init(picturesApi: PicturesAPI, imageLoader: ImageLoader) {
        self.picturesApi = picturesApi
        self.imageLoader = imageLoader
    }
    
    func onViewPrepared() {
        changeViewState(state: .askForCount)
    }

    private func loadPicturesList(maxCount: Int) {
        if maxCount == 0 {
            changeViewState(state: .empty)
            return
        }
        
        changeViewState(state: .loading)
        picturesApi.requestPicturesList(completion: { [weak self] pictures, error in
            if let error = error {
                self?.changeViewState(state: .error(error))
                return
            }
            
            if pictures.isEmpty {
               self?.changeViewState(state: .empty)
                return
            }
            
            let selectedPictures = Array(pictures.shuffled().prefix(maxCount))
            self?.prepareData(from: selectedPictures)
        })
    }
    
    private func prepareData(from pictures: [PictureData]) {
        let cellModels = pictures.map({
            ImageCellViewModel(imageId: $0.id, authorName: $0.author, loadPicture: { [weak self] request in
                self?.imageLoader.loadPicture(request: request)
            })
        })
        
        var rowModels = [ImageGalleryRowViewModel]()
        var rowCells = [ImageCellViewModel]()
        for index in 0..<cellModels.count {
            rowCells.append(cellModels[index])
            if rowCells.count == 5 {
                rowModels.append(ImageGalleryRowViewModel(cells: rowCells))
                rowCells.removeAll()
            }
        }
        if !rowCells.isEmpty {
            rowModels.append(ImageGalleryRowViewModel(cells: rowCells))
        }
        
        self.data = rowModels
        self.changeViewState(state: .pictures)
    }
    
    private func changeViewState(state: ImageGalleryViewState) {
        DispatchQueue.main.async {
            self.onViewStateChanged?(state)
        }
    }
}
