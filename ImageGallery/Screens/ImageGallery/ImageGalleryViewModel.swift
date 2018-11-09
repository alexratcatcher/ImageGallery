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
}


struct RowViewModel {
    let cells: [CellViewModel]
    let isLastRow: Bool
}


enum ImageGalleryViewState {
    case loading
    case empty
    case pictures
    case error(Error)
}


class ImageGalleryViewModel {
    
    private let picturesApi: LoremPicsumAPI
    
    var data = [RowViewModel]()
    
    var requiredPicturesCount: Int = 0 {
        didSet {
            loadPicturesList(maxCount: requiredPicturesCount)
        }
    }
    
    var onViewStateChanged: ((ImageGalleryViewState)->Void)?
    
    init(picturesApi: LoremPicsumAPI) {
        self.picturesApi = picturesApi
        
        let firstRow = [CellViewModel(imageId: nil, authorName: "test1"),
                        CellViewModel(imageId: nil, authorName: "test2"),
                        CellViewModel(imageId: nil, authorName: "test3"),
                        CellViewModel(imageId: nil, authorName: "test4"),
                        CellViewModel(imageId: nil, authorName: "test5")]
        
        let secondRow = [CellViewModel(imageId: nil, authorName: "test11"),
                         CellViewModel(imageId: nil, authorName: "test12"),
                         CellViewModel(imageId: nil, authorName: "test13"),
                         CellViewModel(imageId: nil, authorName: "test14"),
                         CellViewModel(imageId: nil, authorName: "test15")]
        
        let thirdRow = [CellViewModel(imageId: nil, authorName: "test11"),
                        CellViewModel(imageId: nil, authorName: "test12"),
                        CellViewModel(imageId: nil, authorName: "test13"),
                        CellViewModel(imageId: nil, authorName: "test14"),
                        CellViewModel(imageId: nil, authorName: "test15")]
        
        let forthRow = [CellViewModel(imageId: nil, authorName: "test11"),
                        CellViewModel(imageId: nil, authorName: "test12"),
                        CellViewModel(imageId: nil, authorName: "test13"),
                        CellViewModel(imageId: nil, authorName: "test14"),
                        CellViewModel(imageId: nil, authorName: "test15")]
        
        data = [RowViewModel(cells: firstRow, isLastRow: false),
                RowViewModel(cells: secondRow, isLastRow: false),
                RowViewModel(cells: thirdRow, isLastRow: false),
                RowViewModel(cells: forthRow, isLastRow: true)]
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
            CellViewModel(imageId: $0.id, authorName: $0.author)
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
