//
//  TableViewCell.swift
//  Firebase_Midterm
//
//  Created by ChloeHuHu on 2020/11/20.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!{
        didSet {
            categoryLabel.layer.cornerRadius = 10
            categoryLabel.adjustsFontSizeToFitWidth = true
            categoryLabel.font = UIFont.boldSystemFont(ofSize: categoryLabel.font.pointSize)
            categoryLabel.clipsToBounds = true
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectedBackgroundView = UIView()
    }

}
