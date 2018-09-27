
//
//  CustomSlider.swift
//  Wodeliver
//
//  Created by Anuj Singh on 16/09/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//
import UIKit

class CustomSlider: UISlider {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 3
        return newBounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setThumbImage(UIImage.init(named: "thumb-image"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setThumbImage(UIImage.init(named: "thumb-image"), for: .normal)
    }
    
}
