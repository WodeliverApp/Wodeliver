//
//  ShopperReguestTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 20/09/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class ShopperReguestTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
