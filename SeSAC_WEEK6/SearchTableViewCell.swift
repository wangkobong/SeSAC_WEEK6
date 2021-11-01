//
//  SearchTableViewCell.swift
//  SeSAC_WEEK6
//
//  Created by sungyeon kim on 2021/11/02.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var summaryImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont().GmarketSansBold
        dateLabel.font = UIFont().GmarketSansLight
        contentLabel.font = UIFont().GmarketSansMedium
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
