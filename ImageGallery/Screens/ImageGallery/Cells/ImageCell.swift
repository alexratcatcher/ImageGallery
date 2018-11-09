//
//  ImageCell.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import UIKit


class ImageCell: UICollectionViewCell {
    
    private var imageView: UIImageView!
    private var authorLabel: UILabel!
    private var progressIndicator: UIActivityIndicatorView!
    
    private var imageLoadingRequest: ImageLoadingRequest?
    
    static var reuseIdentifier: String {
        return "ImageCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createViews()
        self.setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createViews()
        self.setConstraints()
    }
    
    override func prepareForReuse() {
        self.imageLoadingRequest?.cancel()
        self.imageLoadingRequest = nil
        
        self.progressIndicator.stopAnimating()
        self.imageView.image = nil
        self.authorLabel.text = nil
        
        super.prepareForReuse()
    }
    
    func showCellModel(_ model: ImageCellViewModel) {
        self.authorLabel.text = model.authorName
        
        if let pictureId = model.imageId {
            progressIndicator.startAnimating()
            
            let request = ImageLoadingRequest(imageId: pictureId)
            request.onImageLoaded = { [weak self] image in
                self?.progressIndicator.stopAnimating()
                self?.imageView.image = image
            }
            model.loadPicture(request)
        }
        else {
            imageView.image = nil
        }
    }
    
    private func createViews() {
        contentView.backgroundColor = Colors.cellBackgroundColor
        contentView.layer.cornerRadius = 12.0
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        
        let imageFrame = CGRect(x: 0, y: 0, width: 150, height: 150)
        imageView = UIImageView(frame: imageFrame)
        imageView.backgroundColor = Colors.imageBackgroundColor
        imageView.contentMode = .scaleAspectFill
        let path = UIBezierPath(roundedRect: imageFrame, cornerRadius: 12)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        imageView.layer.mask = mask
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        authorLabel = UILabel(frame: CGRect.zero)
        authorLabel.font = UIFont.systemFont(ofSize: 13)
        authorLabel.textAlignment = .center
        authorLabel.backgroundColor = Colors.cellBackgroundColor
        contentView.addSubview(authorLabel)
        
        progressIndicator = UIActivityIndicatorView(style: .white)
        progressIndicator.backgroundColor = Colors.imageBackgroundColor
        progressIndicator.hidesWhenStopped = true
        contentView.addSubview(progressIndicator)
    }
    
    private func setConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0)
            ])
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0),
            authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
}
