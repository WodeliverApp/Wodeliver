//
//  CustomSegmentControl.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/21/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import UIKit

@IBDesignable class MySegmentedControl: UISegmentedControl {
    
    @IBInspectable var height: CGFloat = 29 {
        didSet {
            let centerSave = center
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: height)
            center = centerSave
        }
    }
}
