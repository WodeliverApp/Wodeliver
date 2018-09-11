//
//  CurrentOrderTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 09/09/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class CurrentOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnOrderStatus_ref: UIButton!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblOrderId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.cornerRadius = 5.0
        mainView.clipsToBounds = true
        lblOrderStatus.numberOfLines = 0
        lblOrderStatus.sizeToFit()
        lblItemName.numberOfLines = 0
        lblItemName.sizeToFit()
        lblDate.numberOfLines = 0
        lblDate.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func getCellHeight() -> CGFloat {
        return 156.0
    }
    
}
