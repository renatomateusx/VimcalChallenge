//
//  NumbersViewCell.swift
//  VimcalChallenge
//
//  Created by Renato Mateus on 05/06/22.
//

import UIKit

class NumbersViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "NumbersViewCell"

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupItem(with item: Int) {
        self.titleLabel.text = String(item)
    }
}
