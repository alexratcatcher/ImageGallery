//
//  ImageCell.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import UIKit


class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var contentContainer: UIView!
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: "ImageCell", bundle: nil)
    }
    
    static var cellIdentifier: String {
        return "ImageCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentContainer.layer.cornerRadius = 12.0
        imageContainer.layer.cornerRadius = 12.0
    }
    
    func showCellModel(_ model: CellViewModel) {
        self.imageView.image = nil //TODO:
        self.authorLabel.text = model.authorName
    }
}
