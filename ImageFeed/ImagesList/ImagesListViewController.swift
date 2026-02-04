//
//  ViewController.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 30.01.2026.
//

import UIKit

class ImagesListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 200
    }
    
    func configCell(for cell: ImagesListCell) { }
}

extension ImagesListViewController: UITableViewDelegate {
    // Тап на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        
        configCell(for: imageListCell)
        return imageListCell
    }
}
