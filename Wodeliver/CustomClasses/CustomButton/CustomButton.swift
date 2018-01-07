//
//  CustomButton.swift
//  SPCE
//
//  Created by Arvind Kumar Gupta on 02/09/17.
//  Copyright © 2017 Arvind Kumar Gupta. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.backgroundColor = UIColor.red
        self.setTitleColor(UIColor.white, for: .normal)
    }
 
    override public func layoutSubviews() {
        super.layoutSubviews()
         self.backgroundColor = Colors.redBackgroundColor
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }

}
