//
//  OtherHelper.swift
//  Wodeliver
//
//  Created by Anuj Singh on 14/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class OtherHelper {
    static func simpleDialog(_ title: String, _ message: String, _ controller:UIViewController) {
        let alert=UIAlertController(title: title.localized, message: message, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .default, handler: nil));
        controller.present(alert, animated: true, completion: nil)
    }
    static func buttonDialog(_ title: String, _ message: String, _ controller:UIViewController, _ buttonTitle: String, _ shouldCancel: Bool, completionHandler: @escaping () -> Void) {
        let alert=UIAlertController(title: title.localized, message: message, preferredStyle: UIAlertControllerStyle.alert);
        if shouldCancel {
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler: nil))
        }
        alert.addAction(UIAlertAction(title: buttonTitle.localized, style: .default, handler: { action in
            completionHandler()
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    
    static func PushViewController(name:String,viewName: String) -> UIViewController {
        return UIStoryboard(name: name, bundle: nil) .
            instantiateViewController(withIdentifier: "\(viewName)")
    }
    
    static func getLabelHeight(_ text: String, _ width:CGFloat, _ fontSize: CGFloat) -> CGFloat {
        let constraint = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let boundingBox = text.boundingRect(with: constraint, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize), NSAttributedStringKey.paragraphStyle: paragraphStyle], context: nil).size
        return ceil(boundingBox.height)
    }
    
    static func getAttributedLabelHeight(_ text: NSAttributedString, _ width:CGFloat) -> CGFloat {
        let constraint = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraint, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return ceil(boundingBox.height)
    }
    
    static func getLabelSize(_ text: String, _ width:CGFloat, _ fontSize: CGFloat) -> CGSize {
        let constraint = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let boundingBox = text.boundingRect(with: constraint, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize), NSAttributedStringKey.paragraphStyle: paragraphStyle], context: nil).size
        let size = CGSize(width: ceil(boundingBox.width), height: CGFloat(ceil(boundingBox.height)))
        return size
    }
    
    static func loadIndicator(viewToAdd: UIView, isNavigationBar: Bool) -> UIActivityIndicatorView {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        var y:CGFloat = 18
        if isNavigationBar {
            y = y + 64
        }
        indicator.center = CGPoint.init(x: viewToAdd.frame.size.width/2, y: y)
        viewToAdd.addSubview(indicator)
        return indicator
    }
    
    static func scaleImage(image: UIImage, scaledTo newSize: CGFloat) -> UIImage {
        //UIGraphicsBeginImageContext(newSize);
        // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
        // Pass 1.0 to force exact pixel size.
        var finalSize: CGSize!
        if image.size.width > image.size.height {
            finalSize = CGSize.init(width: newSize, height: image.size.height*(newSize/image.size.width))
        }else {
            finalSize = CGSize.init(width: image.size.width*(newSize/image.size.height), height: newSize)
        }
        UIGraphicsBeginImageContextWithOptions(finalSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: finalSize.width, height: finalSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    static func convertImageToBase64(image: UIImage) -> String {
        let imageData = UIImageJPEGRepresentation(image, 0.5)!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }

    static func deviceTimeZone() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "Z"
        let localTimeZoneOffset = dateFormatter.string(from: Date())
        let one = (localTimeZoneOffset as NSString).substring(to: 1)
        let two = (localTimeZoneOffset as NSString).substring(with: NSRange(location: 1, length: 2))
        let three = (localTimeZoneOffset as NSString).substring(with: NSRange(location: 3, length: 2))
        let result = "UTC\(one )\(two):\(three)"
        return result
    }
}

class ProgressBar{
    static func showActivityIndicator(view: UIView, withOpaqueOverlay: Bool) {
        
        // this will be the alignment view for the activity indicator
        var superView: UIView = view
        
        // if we want an opaque overlay, do that work first then put the activity indicator within that view; else just use the passed UIView to center it
        if withOpaqueOverlay {
            let overlay = UIView()
            overlay.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
                //CGRectMake(0.0, 0.0, view.frame.width, view.frame.height)
            overlay.layer.backgroundColor = UIColor.lightText.cgColor
            overlay.alpha = 1
            overlay.tag = 1
            overlay.center = superView.center
            overlay.isHidden = false
            superView.addSubview(overlay)
            superView.bringSubview(toFront: overlay)
            superView = overlay
        }
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        indicator.center = superView.center
        indicator.tag = 1
        indicator.isHidden = false
        
        superView.addSubview(indicator)
        superView.bringSubview(toFront: indicator)
        
        indicator.startAnimating()
        
        // also indicate network activity in the status bar
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    static func hideActivityIndicator(view: UIView) {
        
        // stop the network activity animation in the status bar
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // remove the activity indicator and optional overlay views
        view.viewWithTag(1)?.removeFromSuperview()
        view.viewWithTag(1)?.removeFromSuperview()
    }
}
