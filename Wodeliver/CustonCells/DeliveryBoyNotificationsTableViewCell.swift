//
//  DeliveryBoyNotificationsTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 11/09/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class DeliveryBoyNotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblOrderTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backView.layer.cornerRadius = 5.0
        self.backView.clipsToBounds = true
        self.contentView.backgroundColor = Colors.viewBackgroundColor
        
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        let f = contentView.frame
//        let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(10, 10, 10, 10))
//        contentView.frame = fr
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
