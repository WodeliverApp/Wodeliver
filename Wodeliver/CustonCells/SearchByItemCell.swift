//
//  SearchByItemCell.swift
//  Wodeliver
//
//  Created by Roshani Singh on 12/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class SearchByItemCell: UITableViewCell {
    
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var soldLbl: UILabel!
    @IBOutlet weak var orderBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backView.layer.cornerRadius = 5.0
        self.backView.clipsToBounds = true
        self.contentView.backgroundColor = Colors.viewBackgroundColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    /**
     * Function to use for get cell Height
     * @param None
     * @return : Hight of cell
     **/
    class func getCellHeight() -> CGFloat {
        return 143.0
    }
    
}
