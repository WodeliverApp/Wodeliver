//
//  StoreDetailCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 14/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class StoreDetailCell: UITableViewCell {

    @IBOutlet weak var storeImg: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var ratingView: UIStackView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var dislikeBtn: UIButton!
    @IBOutlet weak var distanceBtn: UIButton!
    @IBOutlet weak var rating1Btn: UIButton!
     @IBOutlet weak var rating2Btn: UIButton!
     @IBOutlet weak var rating3Btn: UIButton!
     @IBOutlet weak var rating4Btn: UIButton!
     @IBOutlet weak var rating5Btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
