//
//  ResetPasswordViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 04/10/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    
    @IBOutlet weak var btnSave_ref: CustomButton!
    @IBOutlet weak var txtConfirmPassword: FloatLabelTextField!
    @IBOutlet weak var txtNewPassword: FloatLabelTextField!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var txtOldPassword: FloatLabelTextField!
    @IBOutlet weak var txtEmail: FloatLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reset Password"
        viewCustomization()
        txtEmail.text =  UserManager.getUserDetail()["email"].stringValue
        txtEmail.isEnabled = false
        navigationController?.navigationBar.isHidden = false
        
    }
    
    func viewCustomization(){
        //self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        // self.tblCart.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.shadowView.backgroundColor = UIColor.white
    }
    
    @IBAction func btnSave_Action(_ sender: UIButton) {
        if txtOldPassword.text?.count == 0{
            OtherHelper.simpleDialog("Error", "Please enter old password", self)
            return
        }
        if txtNewPassword.text?.count == 0{
            OtherHelper.simpleDialog("Error", "Please enter new password", self)
            return
        }
        if txtConfirmPassword.text?.count == 0{
            OtherHelper.simpleDialog("Error", "Please enter confirm password", self)
            return
        }
        if txtNewPassword.text != txtConfirmPassword.text{
            OtherHelper.simpleDialog("Error", "New password and confirm password must be same.", self)
            return
        }
        
        btnSave_ref.loadingIndicator(true)
        NetworkHelper.post(url: Path.resetPassword, param: ["email":txtEmail.text ?? "" , "oldPassword":txtOldPassword.text ?? "", "newPassword": txtNewPassword.text ?? ""    ], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            self.btnSave_ref.loadingIndicator(false)
            guard (json != nil) else {
                return
            }
            OtherHelper.buttonDialog("Sucess", "Password Change Successfully", self, "Done", false, completionHandler: {
                self.navigationController?.popViewController(animated: true)
            })
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ResetPasswordViewController: UITextFieldDelegate{
    
    //MARK:- UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail
        {
            txtOldPassword.becomeFirstResponder()
        }else if textField == txtOldPassword
        {
            txtNewPassword.becomeFirstResponder()
        }else if textField == txtNewPassword{
            txtConfirmPassword.becomeFirstResponder()
        }else if textField == txtConfirmPassword{
            txtConfirmPassword.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldRect: CGRect = self.view.window!.convert(textField.bounds, from: textField)
        let viewRect: CGRect = self.view.window!.convert(self.view.bounds, from: self.view!)
        let midline: CGFloat = textFieldRect.origin.y + 0.5 * textFieldRect.size.height
        let numerator: CGFloat = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height
        let denominator: CGFloat = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height
        var heightFraction: CGFloat = numerator / denominator
        if heightFraction < 0.0 {
            heightFraction = 0.0
        }
        else if heightFraction > 1.0 {
            heightFraction = 1.0
        }
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction)
        var viewFrame: CGRect = self.view.frame
        viewFrame.origin.y -= animatedDistance
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.3)
        self.view!.frame = viewFrame
        UIView.commitAnimations()
        self.view.layoutIfNeeded()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var viewFrame: CGRect = self.view.frame
        viewFrame.origin.y += animatedDistance
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.3)
        self.view!.frame = viewFrame
        UIView.commitAnimations()
        self.view.layoutIfNeeded()
    }
}
