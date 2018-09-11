//
//  WodeliverImageView.swift
//  Wodeliver
//
//  Created by Anuj Singh on 06/08/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

@IBDesignable
class WodeliverImageView: UIImageView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    @IBInspectable var makeCircular:Bool = false{
        didSet{
            if makeCircular {
                clipsToBounds = true
                layer.cornerRadius = frame.size.width/2
            }
        }
    }
    
    @IBInspectable var haveBorder:Bool = false{
        didSet{
            if haveBorder {
                layer.borderColor = borderColor.cgColor
                layer.borderWidth = borderWidth
            }
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.lightGray{
        didSet{
            if haveBorder {
                layer.borderColor = borderColor.cgColor
            }
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.3{
        didSet{
            if haveBorder {
                layer.borderWidth = borderWidth
            }
        }
    }
}
