//
//  HistoryFooterTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 11/09/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class HistoryFooterTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblOrderAmount: UILabel!
    @IBOutlet weak var lblTitile: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        //self.contentView.backgroundColor = Colors.redBackgroundColor
        self.contentView.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func getCellHeight() -> CGFloat {
        return 44.0
    }
    
}
