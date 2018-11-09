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
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 9.0))
        header.backgroundColor = UIColor.darkGray
        tableView.tableHeaderView = header
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 9.0))
        footer.backgroundColor = UIColor.darkGray
        tableView.tableFooterView = footer

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
        
        viewModel.onViewStateChanged = { [weak self] state in
            self?.showViewState(state)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        askForPicturesCount()
    }
    
    func showViewState(_ state: ImageGalleryViewState) {
        switch state {
        case .askForCount:
            self.askForPicturesCount()
        case .loading:
            break
        case .error(let error):
            break
        case .empty:
            break
        case .pictures:
            tableView.reloadData()
        }
    }
    
    func askForPicturesCount() {
        let alert = UIAlertController(title: "", message: "Enter desired pictures count", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] action in
            if let text = alert.textFields?.first?.text, let count = Int(text) {
                self?.viewModel.requiredPicturesCount = count
            }
        })
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
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
