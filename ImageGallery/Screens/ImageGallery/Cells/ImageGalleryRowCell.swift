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
            let sectionInsets = UIEdgeInsets(top: 18.0, left: 18.0, bottom: viewModel.isLastRow ? 18.0 : 0, right: 18.0)
            collectionLayout.sectionInset = sectionInsets
            
            let height = CGFloat(194 + (viewModel.isLastRow ? 18 : 0))
            if cellHeight.constant != height {
                cellHeight.constant = height
            }
            
            self.collectionView.reloadData()
        }
    }
    
    private var collectionLayout: UICollectionViewFlowLayout!
    private var collectionView: UICollectionView!
    private var cellHeight: NSLayoutConstraint!
    
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
        collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.itemSize = CGSize(width: 150, height: 175)
        collectionLayout.minimumInteritemSpacing = 18.0
        collectionLayout.minimumLineSpacing = 18.0
        collectionLayout.sectionInset = UIEdgeInsets(top: 18.0, left: 18.0, bottom: 0.0, right: 18.0)
        
        collectionView = UICollectionView(frame: contentView.frame, collectionViewLayout: collectionLayout)
        contentView.addSubview(collectionView)
        
        collectionView.register(ImageCell.nib, forCellWithReuseIdentifier: ImageCell.cellIdentifier)
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor.darkGray
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        cellHeight = collectionView.heightAnchor.constraint(equalToConstant: 194)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellHeight
        ])
    }
}


extension ImageGalleryRowCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.cellIdentifier, for: indexPath) as! ImageCell
        
        let model = viewModel.cells[indexPath.row]
        cell.showCellModel(model)
        
        return cell
    }
}
