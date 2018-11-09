//
//  ImageGalleryRowCell.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import UIKit


class ImageGalleryRowCell: UITableViewCell {
    
    var viewModel: RowViewModel! {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private var collectionView: UICollectionView!
    
    static var cellIdentifier: String {
        return "ImageGalleryRowCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createViews()
    }
    
    private func createViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 175)
        layout.minimumInteritemSpacing = 18.0
        layout.minimumLineSpacing = 18.0
        layout.sectionInset = UIEdgeInsets(top: 9.0, left: 18.0, bottom: 9.0, right: 18.0)
        
        collectionView = UICollectionView(frame: contentView.frame, collectionViewLayout: layout)
        contentView.addSubview(collectionView)
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor.darkGray
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 194)
        ])
    }
}


extension ImageGalleryRowCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
        
        let model = viewModel.cells[indexPath.row]
        cell.showCellModel(model)
        
        return cell
    }
}
