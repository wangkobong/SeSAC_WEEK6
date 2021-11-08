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
    
    func configureCell(row: UserDiary) {

        contentLabel.text = row.diaryContent
        titleLabel.text = row.diaryTitle
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM월-dd일"
        
        dateLabel.text = dateFormatter.string(from: row.writeDate)
        
    }
    
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
