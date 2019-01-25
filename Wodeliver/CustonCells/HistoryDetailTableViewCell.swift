//
//  HistoryDetailTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/21/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import UIKit

class HistoryDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTotalItemAmount: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
         self.selectionStyle = .none
        // Initialization code
    }

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
        return 60.0
    }
}
