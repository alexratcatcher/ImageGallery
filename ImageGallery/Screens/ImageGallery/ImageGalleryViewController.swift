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
    private var progressIndicator: UIActivityIndicatorView!
    private var noPicturesLabel: UILabel!
    
    class func instantiate() -> ImageGalleryViewController {
        return ImageGalleryViewController(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        createViews()
        setConstraints()
        
        tableView.isHidden = true
        progressIndicator.isHidden = true
        noPicturesLabel.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onViewStateChanged = { [weak self] state in
            self?.showViewState(state)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.onViewPrepared()
    }
    
    func showViewState(_ state: ImageGalleryViewState) {
        switch state {
            
        case .askForCount:
            tableView.isHidden = true
            noPicturesLabel.isHidden = true
            progressIndicator.isHidden = true
            askForPicturesCount()
            
        case .loading:
            tableView.isHidden = true
            noPicturesLabel.isHidden = true
            progressIndicator.startAnimating()
            break
            
        case .error(let error):
            progressIndicator.stopAnimating()
            tableView.isHidden = true
            noPicturesLabel.isHidden = true
            showErrorMessage(error.localizedDescription)
            break
            
        case .empty:
            progressIndicator.stopAnimating()
            tableView.isHidden = true
            noPicturesLabel.isHidden = false
            break
            
        case .pictures:
            progressIndicator.stopAnimating()
            tableView.isHidden = false
            noPicturesLabel.isHidden = true
            tableView.reloadData()
        }
    }
    
    private func askForPicturesCount() {
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
    
    private func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alert.addAction(closeAction)
        
        present(alert, animated: true, completion: nil)
    }
}


extension ImageGalleryViewController {
    
    private func createViews() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.darkGray
        self.view = view
        
        createTableView()
        createProgressIndicator()
        createNoPicturesLabel()
    }
    
    private func createTableView() {
        tableView = UITableView(frame: view.frame, style: .plain)
        view.addSubview(tableView)
        
        tableView.register(ImageGalleryRowCell.self, forCellReuseIdentifier: ImageGalleryRowCell.reuseIdentifier)
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
    }
    
    private func createProgressIndicator() {
        progressIndicator = UIActivityIndicatorView(style: .white)
        progressIndicator.hidesWhenStopped = true
        view.addSubview(progressIndicator)
    }
    
    private func createNoPicturesLabel() {
        noPicturesLabel = UILabel(frame: CGRect.zero)
        noPicturesLabel.font = UIFont.systemFont(ofSize: 16)
        noPicturesLabel.textColor = UIColor.white
        noPicturesLabel.textAlignment = .center
        noPicturesLabel.text = "No pictures found"
        view.addSubview(noPicturesLabel)
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        noPicturesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noPicturesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noPicturesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
}


extension ImageGalleryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageGalleryRowCell.reuseIdentifier, for: indexPath) as! ImageGalleryRowCell
        
        let model = viewModel.data[indexPath.row]
        cell.viewModel = model
        
        return cell
    }
}
