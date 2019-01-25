//
//  MyWalletViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 09/10/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Stripe

class MyWalletViewController: UIViewController,STPAddCardViewControllerDelegate, STPPaymentCardTextFieldDelegate, STPPaymentMethodsViewControllerDelegate  {
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
      //  <#code#>
    }
    
    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        //<#code#>
    }
    
    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
      //  <#code#>
    }
    

    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var btnWalletToBank_ref: CustomButton!
    @IBOutlet weak var btnDone_ref: CustomButton!
    @IBOutlet weak var btnTopUp_ref: CustomButton!
    @IBOutlet weak var upperView: UIView!
  //  let customerContext = STPCustomerContext(keyProvider: MyAPIClient.sharedClient)
    let paymentCardTextField = STPPaymentCardTextField()
  
//    init() {
//        self.paymentContext = STPPaymentContext(customerContext: customerContext)
//        super.init(nibName: nil, bundle: nil)
//        self.paymentContext.delegate = self
//        self.paymentContext.hostViewController = self
//        self.paymentContext.paymentAmount = 5000 // This is in cents, i.e. $50 USD
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCustomization()
        customToolBar()
        
        paymentView.isHidden = true
        btnDone_ref.isEnabled = false
        
        paymentCardTextField.delegate = self
        
        // Add payment card text field to view
        paymentCardTextField.frame = CGRect.init(x: 10, y: 200, width: self.view.frame.width - 20, height: 30)
      //  view.addSubview(paymentCardTextField)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissView(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWalletBalance()
    }
    
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        // Toggle buy button state
      //  buyButton.enabled = textField.isValid
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
        txtAmount.inputAccessoryView = toolBar
    }
    
    //MARK:- UIToolBar Button Actions
    
    @objc func doneClick() {
        self.view.endEditing(true)
    }
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    // MARK: - UIButton Actions
    
    @IBAction func btnWalleToBank_action(_ sender: CustomButton) {
        if paymentView.isHidden {
            paymentView.isHidden = false
        } else {
            paymentView.isHidden = true
        }
    }
    @IBAction func btnTopUp_Action(_ sender: CustomButton) {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self

        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
        
        
//        // Setup customer context
//        let customerContext = STPCustomerContext(keyProvider: StripeCredential.publishableKey as! STPEphemeralKeyProvider)
//        
//        // Setup payment methods view controller
//        let paymentMethodsViewController = STPPaymentMethodsViewController(configuration: STPPaymentConfiguration.shared(), theme: STPTheme.default(), customerContext: customerContext, delegate: self)
//        
//        // Present payment methods view controller
//        let navigationController = UINavigationController(rootViewController: paymentMethodsViewController)
//        present(navigationController, animated: true)

        
    }
    @IBAction func btnDone_Action(_ sender: CustomButton) {
        if txtAmount.text!.count > 0{
            NetworkHelper.post(url: Path.baseURL + "banktransfer", param: ["userId": UserManager.getUserId(), "amountToBeTransferred" : txtAmount.text ?? "0"], self, completionHandler: {[weak self] json, error in
                guard let `self` = self else { return }
                guard let json = json else {
                    return
                }
                if json["response"].dictionary != nil{
                    self.view.endEditing(true)
                    self.paymentView.isHidden = true
                    self.txtAmount.text = ""
                    OtherHelper.simpleDialog("Sucess", "Your request has been sent successfully and will be processed soon. You will be notified soon.", self)
                }
            })
        }else{
            OtherHelper.simpleDialog("Error", "Please enter amount", self)
        }
       
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyWalletViewController{
// MARK: STPAddCardViewControllerDelegate

func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
    // Dismiss add card view controller
    dismiss(animated: true)
}

func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
    print(token)
    dismiss(animated: true, completion: nil)
//    submitTokenToBackend(token, completion: { (error: Error?) in
//        if let error = error {
//            // Show error in add card view controller
//            completion(error)
//        }
//        else {
//            // Notify add card view controller that token creation was handled successfully
//            completion(nil)
//
//            // Dismiss add card view controller
//            dismiss(animated: true)
//        }
//    })
}
}
extension MyWalletViewController: UITextFieldDelegate{
    //MARK:- UITextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtAmount{
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let numberOfChars = newText.count
            if numberOfChars > 0 {
                btnDone_ref.isEnabled = true
            }else{
                btnDone_ref.isEnabled = false
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
