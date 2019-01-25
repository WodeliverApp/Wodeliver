//
//  HistoryHeaderTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/21/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import UIKit

class HistoryHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
         self.selectionStyle = .none
        self.contentView.backgroundColor = Colors.redBackgroundColor
         self.contentView.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10)
        // Initialization code
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//       self.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10)
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
        // Configure the view for the selected state
    }
    /**
     * Function to use for get cell Height
     * @param None
     * @return : Hight of cell
     **/
    class func getCellHeight() -> CGFloat {
        return 44.0
    }
}
