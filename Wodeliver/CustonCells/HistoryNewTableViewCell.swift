//
//  HistoryNewTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/21/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import UIKit

class HistoryNewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNew: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
         self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.lblNew.layer.cornerRadius = 5.0
        self.lblNew.layer.masksToBounds = true
        // Configure the view for the selected state
    }
    /**
     * Function to use for get cell Height
     * @param None
     * @return : Hight of cell
     **/
    class func getCellHeight() -> CGFloat {
        return 85.0
    }
}
