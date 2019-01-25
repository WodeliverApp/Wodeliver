//
//  AddressTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 20/06/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnEdit_ref: UIButton!
    @IBOutlet weak var btnCheck_ref: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func getCellHeight() -> CGFloat {
        return 101.0
    }
    
}
