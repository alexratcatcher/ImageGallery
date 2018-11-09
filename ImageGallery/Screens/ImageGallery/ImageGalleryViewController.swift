//
//  ImageGalleryViewController.swift
//  ImageGallery
//
//  Created by Alexey Berkov on 09/11/2018.
//  Copyright © 2018 Alexey Berkov. All rights reserved.
//

import UIKit


class ImageGalleryViewController: UIViewController {
    
    var viewModel: ImageGalleryViewModel!
    
    private var tableView: UITableView!
    
    class func instantiate() -> ImageGalleryViewController {
        return ImageGalleryViewController(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        
        let tableView = UITableView(frame: view.frame, style: .plain)
        self.tableView = tableView
        view.addSubview(tableView)
        
        tableView.register(ImageGalleryRowCell.self, forCellReuseIdentifier: ImageGalleryRowCell.cellIdentifier)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = UIColor.darkGray

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 193
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
}


extension ImageGalleryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageGalleryRowCell.cellIdentifier, for: indexPath) as! ImageGalleryRowCell
        
        let model = viewModel.data[indexPath.row]
        cell.viewModel = model
        
        return cell
    }
}
