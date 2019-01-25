//
//  ItemListTableViewCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 20/09/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class ItemListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backView.layer.cornerRadius = 5.0
        self.backView.clipsToBounds = true
        self.contentView.backgroundColor = Colors.viewBackgroundColor
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}