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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    private var imageLoadingTask: URLSessionTask?
    
    static var nib: UINib {
        return UINib(nibName: "ImageCell", bundle: nil)
    }
    
    static var cellIdentifier: String {
        return "ImageCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentContainer.layer.cornerRadius = 12.0
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 150, height: 150), cornerRadius: 12)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        imageView.layer.mask = mask
    }
    
    override func prepareForReuse() {
        self.imageLoadingTask?.cancel()
        self.imageLoadingTask = nil
        
        self.imageView.image = nil
        self.authorLabel.text = nil
        
        super.prepareForReuse()
    }
    
    func showCellModel(_ model: CellViewModel) {
        self.imageView.image = nil //TODO:
        self.authorLabel.text = model.authorName
        
        if let pictureId = model.imageId {
            imageLoadingTask = model.imageLoader.loadPicture(withId: pictureId, completion: { [weak self] image in
                self?.imageView.image = image
            })
        }
    }
}
