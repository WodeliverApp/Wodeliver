//
//  AdvertismentTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 20/04/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class AdvertismentTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
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
    
}
