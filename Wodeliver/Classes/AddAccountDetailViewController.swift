//
//  AddAccountDetailViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 04/10/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class AddAccountDetailViewController: UIViewController {

    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    
    @IBOutlet weak var stackView: CustomStackView!
    @IBOutlet weak var btnSave_ref: CustomButton!
    @IBOutlet weak var txtSwift: FloatLabelTextField!
    @IBOutlet weak var txtAddress: FloatLabelTextField!
    @IBOutlet weak var txtAccountNumber: FloatLabelTextField!
    @IBOutlet weak var txtBankName: FloatLabelTextField!
    @IBOutlet weak var txtAccountName: FloatLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    // Do any additional setup after loading the view.
        title = "Add Bank Account Details"
       geBankDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewCustomization()
    }
    func viewCustomization(){
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.stackView.backgroundColor = UIColor.white
    }
    
    @IBAction func btnSave_Action(_ sender: UIButton) {
        if txtAccountName.text!.count > 0 && txtBankName.text!.count > 0 && txtAccountNumber.text!.count > 0 && txtAddress.text!.count > 0 && txtSwift.text!.count > 0{
            let param : [String:Any] = ["userId":UserManager.getUserId(), "bankAddress":txtAddress.text ?? "", "accountHolderName":txtAccountName.text ?? "", "bankName": txtBankName.text ?? "", "swiftCode":txtSwift.text ?? "", "accountNumber": txtAccountNumber.text ?? ""]
            saveBankDetails(param: param)
        }else{
            OtherHelper.simpleDialog("Error", "All fields are required", self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func saveBankDetails(param : [String : Any])  {
        NetworkHelper.post(url: Path.baseURL+"bank", param: param, self, completionHandler: {[weak self] json, error in
            guard self != nil else { return }
            guard (json != nil) else {
                return
            }
          OtherHelper.simpleDialog("Save", "Bank Detail Updated", self!)
        })
    }
    
    func geBankDetails() {
        NetworkHelper.get(url: Path.baseURL + "bank", param: ["userId": UserManager.getUserId()], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            if let response = json["response"].array{
                self.txtBankName.text = response.first!["bankName"].stringValue
                self.txtAccountName.text = response.first!["accountHolderName"].stringValue
                self.txtSwift.text = response.first!["swiftCode"].stringValue
                 self.txtAddress.text = response.first!["bankAddress"].stringValue
                 self.txtAccountNumber.text = response.first!["accountNumber"].stringValue
            }
            
        })
    }

}
extension AddAccountDetailViewController: UITextFieldDelegate{
    
    //MARK:- UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtAccountName
        {
            txtBankName.becomeFirstResponder()
        }else if textField == txtBankName
        {
            txtAccountNumber.becomeFirstResponder()
        }else if textField == txtAccountNumber{
            txtAddress.becomeFirstResponder()
        }else if textField == txtAddress{
            txtSwift.becomeFirstResponder()
        }else if textField == txtSwift{
            txtSwift.resignFirstResponder()
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
