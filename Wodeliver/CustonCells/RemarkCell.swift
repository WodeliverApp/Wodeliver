//
//  RemarkCell.swift
//  Wodeliver
//
//  Created by Anuj Singh on 16/03/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class RemarkCell: UITableViewCell {

    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
