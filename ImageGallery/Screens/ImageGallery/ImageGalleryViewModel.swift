//
//  ImageGalleryViewModel.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import Foundation


struct CellViewModel {
    let imagePath: URL?
    let authorName: String?
}


struct RowViewModel {
    let cells: [CellViewModel]
    let isLastRow: Bool
}


class ImageGalleryViewModel {
    
    var data = [RowViewModel]()
    
    init() {
        let firstRow = [CellViewModel(imagePath: nil, authorName: "test1"),
                        CellViewModel(imagePath: nil, authorName: "test2"),
                        CellViewModel(imagePath: nil, authorName: "test3"),
                        CellViewModel(imagePath: nil, authorName: "test4"),
                        CellViewModel(imagePath: nil, authorName: "test5")]
        
        let secondRow = [CellViewModel(imagePath: nil, authorName: "test11"),
                         CellViewModel(imagePath: nil, authorName: "test12"),
                         CellViewModel(imagePath: nil, authorName: "test13"),
                         CellViewModel(imagePath: nil, authorName: "test14"),
                         CellViewModel(imagePath: nil, authorName: "test15")]
        
        let thirdRow = [CellViewModel(imagePath: nil, authorName: "test11"),
                         CellViewModel(imagePath: nil, authorName: "test12"),
                         CellViewModel(imagePath: nil, authorName: "test13"),
                         CellViewModel(imagePath: nil, authorName: "test14"),
                         CellViewModel(imagePath: nil, authorName: "test15")]
        
        let forthRow = [CellViewModel(imagePath: nil, authorName: "test11"),
                         CellViewModel(imagePath: nil, authorName: "test12"),
                         CellViewModel(imagePath: nil, authorName: "test13"),
                         CellViewModel(imagePath: nil, authorName: "test14"),
                         CellViewModel(imagePath: nil, authorName: "test15")]
        
        data = [RowViewModel(cells: firstRow, isLastRow: false),
                RowViewModel(cells: secondRow, isLastRow: false),
                RowViewModel(cells: thirdRow, isLastRow: false),
                RowViewModel(cells: forthRow, isLastRow: true)]
    }
}
