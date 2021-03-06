//
//  StoreHistoryTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class StoreHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var btnEdit_ref: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblProdcutCategory: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backView.layer.cornerRadius = 5.0
        self.backView.layer.borderWidth = 1.0
        self.backView.layer.borderColor = UIColor.white.cgColor
        self.backView.clipsToBounds = true
        
        self.backView.layer.shadowColor = UIColor.lightGray.cgColor
        self.backView.layer.shadowOffset = CGSize(width: 1, height: 5.0)
        self.backView.layer.shadowRadius = 2.0
        self.backView.layer.shadowOpacity = 1.0
        self.backView.layer.masksToBounds = true
        self.backView.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.backView.layer.cornerRadius).cgPath
        
        self.contentView.backgroundColor = Colors.viewBackgroundColor
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        self.contentView.preservesSuperviewLayoutMargins = false
        self.contentView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
//    () {
//        super.layoutSubviews()
//
//        self.preservesSuperviewLayoutMargins = false
//        self.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//    }
    class func getCellHeight() -> CGFloat {
        return 165.0
    }
    class func getCellHeightAdvertisment() -> CGFloat {
        return 245.0
    }
}
