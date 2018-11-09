//
//  ImageGalleryViewModel.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import Foundation


struct CellViewModel {
    let imageId: Int?
    let authorName: String?
    let imageLoader: ImageLoader
}


struct RowViewModel {
    let cells: [CellViewModel]
    let isLastRow: Bool
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
    
    var data = [RowViewModel]()
    
    var requiredPicturesCount: Int = 0 {
        didSet {
            loadPicturesList(maxCount: requiredPicturesCount)
        }
    }
    
    var onViewStateChanged: ((ImageGalleryViewState)->Void)?
    
    init(picturesApi: PicturesAPI, imageLoader: ImageLoader) {
        self.picturesApi = picturesApi
        self.imageLoader = imageLoader
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
            
            let preparedPictures = Array(pictures.shuffled().prefix(maxCount))
            self?.prepareData(from: preparedPictures)
        })
    }
    
    private func prepareData(from pictures: [PictureData]) {
        let cellModels = pictures.map({
            CellViewModel(imageId: $0.id, authorName: $0.author, imageLoader: self.imageLoader)
        })
        
        var rowModels = [RowViewModel]()
        var rowCells = [CellViewModel]()
        for index in 0..<cellModels.count {
            rowCells.append(cellModels[index])
            if rowCells.count == 5 {
                let isLast = index == cellModels.count - 1
                rowModels.append(RowViewModel(cells: rowCells, isLastRow: isLast))
                rowCells.removeAll()
            }
        }
        if !rowCells.isEmpty {
            rowModels.append(RowViewModel(cells: rowCells, isLastRow: true))
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
