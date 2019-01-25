//
//  DeliveryWalletViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 06/11/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Stripe

class DeliveryWalletViewController: UIViewController,STPAddCardViewControllerDelegate, STPPaymentCardTextFieldDelegate, STPPaymentMethodsViewControllerDelegate {

    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    var stripeToken : String = ""
    
    @IBOutlet weak var rechargeView: UIView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var bankView: UIView!
    @IBOutlet weak var btnRecahrge_ref: CustomButton!
    @IBOutlet weak var btnWallet_ref: CustomButton!
    @IBOutlet weak var btnBank_ref: CustomButton!
    @IBOutlet weak var btnTopup_ref: UIButton!
    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var lblFrozenBalance: UILabel!
    @IBOutlet weak var lblDepositBalance: UILabel!
    @IBOutlet weak var txtRecharge_ref: UITextField!
    @IBOutlet weak var txtWallet_ref: UITextField!
    @IBOutlet weak var txtBank_ref: UITextField!
    @IBOutlet weak var btnRecahrgeDone_ref: UIButton!
    @IBOutlet weak var btnWalletDone_ref: UIButton!
    @IBOutlet weak var btnBankDone_ref: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rechargeView.isHidden = true
        walletView.isHidden = true
        bankView.isHidden = true
        viewCustomization()
        customToolBar()
        btnRecahrgeDone_ref.isEnabled = false
        btnBankDone_ref.isEnabled = false
        btnWalletDone_ref.isEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissView(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWalletBalance()
        getDepositAmount()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnBank_ref.backgroundColor = UIColor.gray
    }
    
    func customToolBar()  {
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.tintColor = Colors.redBackgroundColor
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
       let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtBank_ref.inputAccessoryView = toolBar
        txtWallet_ref.inputAccessoryView = toolBar
        txtRecharge_ref.inputAccessoryView = toolBar
    }
    
    //MARK:- UIToolBar Button Actions
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @objc func doneClick() {
        self.view.endEditing(true)
    }
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    func viewCustomization(){
        self.title = "My Wallet"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        //  self.tblTransactions.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        btnWallet_ref.layer.cornerRadius = 5.0
        btnWallet_ref.layer.masksToBounds = true
        btnWallet_ref.clipsToBounds = true
        btnBank_ref.layer.cornerRadius = 5.0
        btnBank_ref.layer.masksToBounds = true
        btnBank_ref.clipsToBounds = true
        btnTopup_ref.layer.cornerRadius = 5.0
        btnTopup_ref.layer.masksToBounds = true
        btnTopup_ref.clipsToBounds = true
    }

    @IBAction func btnReachrge_action(_ sender: CustomButton) {
        if rechargeView.isHidden {
            rechargeView.isHidden = false
        } else {
            rechargeView.isHidden = true
        }
    }
    
    @IBAction func btnWallet_action(_ sender: CustomButton) {
        if walletView.isHidden {
            walletView.isHidden = false
        } else {
            walletView.isHidden = true
        }
    }
    
    @IBAction func btnBank_action(_ sender: CustomButton) {
        if bankView.isHidden {
            bankView.isHidden = false
        } else {
            bankView.isHidden = true
        }
    }
  
    @IBAction func btnTopUp_Action(_ sender: CustomButton) {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
    }
    
    @IBAction func btnReachrgeDone_action(_ sender: CustomButton) {
        saveRechargeAmount()
    }
    
    @IBAction func btnWalletDone_action(_ sender: CustomButton) {
        saveWalletAmount()
    }
    
    @IBAction func btnBankDone_action(_ sender: CustomButton) {
        saveBankAmount()
    }
    
    // MARK: - Server Actions
    
    func getWalletBalance() {
        NetworkHelper.post(url: Path.baseURL + "getWalletBalance", param: ["userId": UserManager.getUserId()], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            if let response = json["response"].dictionary{
                self.lblWalletBalance.text = response["balance"]?.stringValue
            }
        })
    }
    
    func getDepositAmount() {
        NetworkHelper.post(url: Path.baseURL + "depositAmount", param: ["userId": UserManager.getUserId()], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            if let response = json["response"].dictionary{
                self.lblWalletBalance.text = response["wallet"]?.stringValue
                self.lblFrozenBalance.text = response["frozen"]?.stringValue
                self.lblDepositBalance.text = response["deposit"]?.stringValue
            }
        })
    }
    
    func saveRechargeAmount() {
        if txtRecharge_ref.text?.count == 0{
            OtherHelper.simpleDialog("Error", "Please enter amount", self)
            return
        }
        NetworkHelper.post(url: Path.baseURL + "deposit", param: ["userId": UserManager.getUserId(), "amount" : txtRecharge_ref.text ?? ""], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            if let response = json["response"].dictionary{
                self.view.endEditing(true)
                self.rechargeView.isHidden = true
                self.txtRecharge_ref.text = ""
                self.lblWalletBalance.text = response["wallet"]?.stringValue
                self.lblDepositBalance.text = response["total"]?.stringValue
            }
        })
    }
    
    func saveWalletAmount() {
        if txtWallet_ref.text?.count == 0{
            OtherHelper.simpleDialog("Error", "Please enter amount", self)
            return
        }
        NetworkHelper.post(url: Path.baseURL + "depositToWallet", param: ["userId": UserManager.getUserId(), "amount" : txtWallet_ref.text ?? ""], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            if let response = json["response"].dictionary{
                self.view.endEditing(true)
                self.walletView.isHidden = true
                self.txtWallet_ref.text = ""
                self.lblWalletBalance.text = response["walletAmount"]?.stringValue
                self.lblFrozenBalance.text = response["freezedAmount"]?.stringValue
                self.lblDepositBalance.text = response["deposit"]?.stringValue
            }
        })
    }
    
    func saveBankAmount() {
        if txtBank_ref.text?.count == 0{
            OtherHelper.simpleDialog("Error", "Please enter amount", self)
            return
        }
        NetworkHelper.post(url: Path.baseURL + "banktransfer", param: ["userId": UserManager.getUserId(), "amountToBeTransferred" : txtBank_ref.text ?? ""], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            if json["response"].dictionary != nil{
                self.view.endEditing(true)
                self.bankView.isHidden = true
                self.txtBank_ref.text = ""
                OtherHelper.simpleDialog("Sucess", "Your request has been sent successfully and will be processed soon. You will be notified soon.", self)
            }
        })
    }
    
    func addMoneyToWallte() {
        if txtBank_ref.text?.count == 0{
            OtherHelper.simpleDialog("Error", "Please enter amount", self)
            return
        }
        NetworkHelper.post(url: Path.baseURL + "addmoneytowallet", param: ["userId": UserManager.getUserId(), "amount" : txtBank_ref.text ?? "" , "stripeToken" : stripeToken], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            if json["response"].dictionary != nil{
                self.view.endEditing(true)
                self.bankView.isHidden = true
                self.txtBank_ref.text = ""
                OtherHelper.simpleDialog("Sucess", "Your request has been sent successfully and will be processed soon. You will be notified soon.", self)
            }
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
extension DeliveryWalletViewController{
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        print(token)
        dismiss(animated: true, completion: nil)
    }
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        //  <#code#>
    }
    
    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        //<#code#>
    }
    
    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        //  <#code#>
    }
}

extension DeliveryWalletViewController: UITextFieldDelegate{
    //MARK:- UITextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtRecharge_ref{
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let numberOfChars = newText.count
            if numberOfChars > 0 {
                btnRecahrgeDone_ref.isEnabled = true
            }else{
                btnRecahrgeDone_ref.isEnabled = false
            }
        }
        if textField == txtWallet_ref{
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let numberOfChars = newText.count
            if numberOfChars > 0 {
                btnWalletDone_ref.isEnabled = true
            }else{
                btnWalletDone_ref.isEnabled = false
            }
        }
        if textField == txtBank_ref{
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let numberOfChars = newText.count
            if numberOfChars > 0 {
                btnBankDone_ref.isEnabled = true
            }else{
                btnBankDone_ref.isEnabled = false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
