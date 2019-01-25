//
//  MenuTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 03/04/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCommentConut: UILabel!
    @IBOutlet weak var lblSoldCount: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblItemCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.backView.layer.cornerRadius = 5.0
        self.backView.clipsToBounds = true
        self.menuImageView.layer.cornerRadius = 5.0
        self.menuImageView.clipsToBounds = true
        self.contentView.backgroundColor = Colors.viewBackgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func getCellHeight() -> CGFloat {
        return 120.0
    }
}
