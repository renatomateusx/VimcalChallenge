//
//  HomeViewController.swift
//  VimcalChallenge
//
//  Created by Renato Mateus on 05/06/22.
//

import UIKit

private enum Orientation {
    case top
    case bottom
}

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private(set) var listOf: [Int] = []
    private var startPoint: Int = 268
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    private func setupData() {
        listOf = Array<Int>(0...500)
        tableView.reloadData()
        calculateScrollTo()
    }
    
    private func setupUI() {
        
        tableView.register(UINib(nibName: NumbersViewCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: NumbersViewCell.identifier)
        tableView.alwaysBounceVertical = false
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func calculateScrollTo() {
        tableView.scrollToRow(at: IndexPath(row: startPoint, section: 0), at: .none, animated: true)
    }
    
    func reloadItems() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Delegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Table view data source
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listOf[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NumbersViewCell.identifier,
                                                       for: indexPath) as? NumbersViewCell  else { return  UITableViewCell() }
        cell.setupItem(with: item)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = listOf.count
        return result
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = tableView.frame.size.height
        let contentYOffset = tableView.contentOffset.y
        let distance = tableView.contentSize.height - contentYOffset

        if contentYOffset < 0 {
            tableView.contentOffset = .zero;
            self.addItemAtTopOfArray()
            if let _ = tableView.indexPathsForVisibleRows?.last {
                removeLastItems()
            }
        } else if distance < height {
            self.addItemAtBottomOfArray()
            if let _ = tableView.indexPathsForVisibleRows?.first {
                removeFirstItems()
            }
        }
        
    }
}

// MARK: - Managing data source
private extension HomeViewController {
    func addItemAtTopOfArray() {
        var previousNumber = 0
        if let topItem = self.listOf.first {
            if topItem == 0 {
                self.listOf.insert(-1, at: 0)
            } else if topItem < 0 {
                previousNumber = topItem + -1
                self.listOf.insert(previousNumber, at: 0)
            }
            reloadItems()
        }
    }
    
    func addItemAtBottomOfArray() {
        if let bottomItem = self.listOf.last {
            let latestBottom = bottomItem + 1
            self.listOf.append(latestBottom)
            reloadItems()
        }
    }
    
    func removeLastItems() {
        if self.listOf.count > 300 {
            self.listOf = self.listOf.dropLast(200)
        }
    }
    
    func removeFirstItems() {
        if self.listOf.count > 500 {
            self.listOf = Array(self.listOf.dropFirst(200))
            tableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
        }
    }
}
