//
//  StoreNotificationTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 14/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class StoreNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var _lblName: UILabel!
    @IBOutlet weak var _ImagePRofile: UIImageView!
    @IBOutlet weak var _lbllike: UILabel!
    @IBOutlet weak var _lblColor: UILabel!
    @IBOutlet weak var _lblTime: UILabel!
    @IBOutlet weak var _btnFollow: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
//        let sidePadding: CGFloat = 20.0
//      let  titleEdgeInsets = UIEdgeInsets(top: 0.0, left: sidePadding, bottom: 0.0, right:  sidePadding)
//      let  contentEdgeInsets = UIEdgeInsets(top: 0.0, left: sidePadding, bottom: 0.0, right: sidePadding)
//        self.contentView.contentEdgeInsets = contentEdgeInsets
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func getCellHeight() -> CGFloat {
        return 75.0
    }
    
}
