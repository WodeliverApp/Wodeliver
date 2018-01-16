//
//  Extensions.swift
//  Myu
//
//  Created by Jovanpreet Randhawa on 13/12/16.
//  Copyright © 2016 Jovanpreet Randhawa. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD
import QuartzCore

extension UIButton {
    func customizeButton(){
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
}

extension Dictionary {
    func nullKeyRemoval() -> Dictionary {
        var dict = self
        
        let keysToRemove = dict.keys.filter { dict[$0] is NSNull }
        for key in keysToRemove {
            dict[key] = ("" as! Value)
        }
        return dict
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UITextView {
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.groupTableViewBackground.cgColor
        border.frame = CGRect(x: 40, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension CALayer {
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}

extension CGFloat {
    func isPortrait() -> Bool {
        if self <= 1.0 {
            return true
        }else {
            return false
        }
    }
}
extension String
{
    func replace(target: String, withString: String) -> String{
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    //    var length: Int {
    //        return self.characters.count
    //    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, count) ..< count)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[Range(start ..< end)])
    }
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var enocoded: String {
        let plainData = self.data(using: .utf8)
        return plainData!.base64EncodedString()
    }
    
    var decoded: String {
        if let decodedData = Data(base64Encoded: self), let decodedString = String(data: decodedData, encoding: .utf8) {
            return decodedString
        }
        return ""
    }
    func htmlAttributedString() -> NSMutableAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return nil }
        return html
    }
}

extension UITableViewController {
    func showHudForTable(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = message
        hud.isUserInteractionEnabled = false
        hud.layer.zPosition = 2
        self.tableView.layer.zPosition = 1
    }
}

extension UIViewController {
    func showHud(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = message
        view.isUserInteractionEnabled = false
    }
    
    func hideHUD() {
        view.isUserInteractionEnabled = true
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}



