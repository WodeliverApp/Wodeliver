//
//  CartTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 24/04/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblItemCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backView.layer.cornerRadius = 5.0
        self.backView.clipsToBounds = true
        self.cartImageView.layer.cornerRadius = 5.0
        self.cartImageView.clipsToBounds = true
        self.contentView.backgroundColor = Colors.viewBackgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
