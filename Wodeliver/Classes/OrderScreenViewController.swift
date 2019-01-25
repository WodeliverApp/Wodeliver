//
//  OrderScreenViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 06/06/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import PassKit

class OrderScreenViewController: UIViewController {
    
    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    var deliveryDate = Date()
    var deliveryTime = Date()
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAddress_ref: UILabel!
    @IBOutlet weak var txtSouce: FloatLabelTextField!
    @IBOutlet weak var txtDeliveryDate: FloatLabelTextField!
    @IBOutlet weak var txtDeliveryTime: FloatLabelTextField!
    @IBOutlet weak var txtDeliveryCost: FloatLabelTextField!
    @IBOutlet weak var txtNotes: FloatLabelTextField!
    var cartList : JSON!
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let ApplePaySwagMerchantID = "merchant.com.spotcodes.wodeliver"
    var storeName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissView(_:)))
        self.view.addGestureRecognizer(tapGesture)
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
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtDeliveryDate.inputAccessoryView = toolBar
        txtDeliveryTime.inputAccessoryView = toolBar
        txtDeliveryCost.inputAccessoryView = toolBar
        txtSouce.text = storeName
        txtSouce.isEnabled = false
        viewCustomization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: .UIKeyboardDidShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: .UIKeyboardDidHide , object: nil)
        
        if let address = UserDefaults.standard.object(forKey: AppConstant.userSelectedAddress){
            let add = JSON.init(parseJSON: address as! String )
            lblAddress_ref.text = add["address"].stringValue
        }else{
            let address : [String: String] = UserDefaults.standard.value(forKey: AppConstant.currentUserLocation) as! [String : String]
            lblAddress_ref.text = address["full_address"]
        }
    }
    
    @objc func doneClick() {
        self.view.endEditing(true)
    }
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification) {
        let keyboardSize:CGSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        PORTRAIT_KEYBOARD_HEIGHT = min(keyboardSize.height, keyboardSize.width)
    }
    
    @objc func keyboardDidHide(_ notification: NSNotification) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewCustomization(){
        self.title = "Order Detail"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        // self.tblCart.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func btnChangeAddress_Action(_ sender: Any) {
    }
    
    @IBAction func btnEditAddress_Action(_ sender: Any) {
    }
    
    @IBAction func btnPlaceOrder_Action(_ sender: Any) {
        
        self.view.endEditing(true)
        if self.isValidate() {
            //            let param = ["state": txtState.text!, "city": txtCity.text!,"address": txtAddress.text!, "details": txtAreaDetail.text!, "landmark": txtLandmark.text!,"zipcode":txtZipCode.text!, "country":txtCountry.text!,"userId":UserManager.getUserId()] as [String : Any]
            //            saveAddressToServer(param: param)
            
            let request = PKPaymentRequest()
            request.merchantIdentifier = ApplePaySwagMerchantID
            request.supportedNetworks = SupportedPaymentNetworks
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            request.countryCode = "US"
            request.currencyCode = "USD"
            request.paymentSummaryItems = [
                PKPaymentSummaryItem(label: "text", amount: 100),
                PKPaymentSummaryItem(label: "test 1", amount: 100)
            ]
            let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
            applePayController?.delegate = self
            self.present(applePayController!, animated: true, completion: nil)
        }
        
    }
    
    func isValidate() -> Bool  {
        if  txtSouce.text?.isEmpty == true ||  txtDeliveryDate.text?.isEmpty == true || txtDeliveryTime.text?.isEmpty == true || txtDeliveryCost.text?.isEmpty == true || txtNotes.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", "All fields are required.", self)
            return false
        }
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension OrderScreenViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {
        completion(PKPaymentAuthorizationStatus.success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //    private func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController!, didSelectShippingAddress address: CNContact!, completion: ((PKPaymentAuthorizationStatus, [AnyObject]?, [AnyObject]?) -> Void)!) {
    //        completion(status: PKPaymentAuthorizationStatus.Success, shippingMethods: nil, summaryItems: nil)
    //    }
}
extension OrderScreenViewController: UITextFieldDelegate{
    
    //MARK:- UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtSouce
        {
            txtDeliveryDate.becomeFirstResponder()
        }else if textField == txtDeliveryDate
        {
            txtDeliveryTime.becomeFirstResponder()
        }else if textField == txtDeliveryTime{
            txtDeliveryCost.becomeFirstResponder()
        }else if txtDeliveryCost == textField{
            txtNotes.becomeFirstResponder()
        }else if textField == txtNotes{
            txtNotes.resignFirstResponder()
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
        switch textField.tag {
        case 3001:
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            datePickerView.tag = 2001
        case 3002:
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .time
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            datePickerView.tag = 2002
        default:
            break
        }
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
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        switch sender.tag {
        case 2001:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            txtDeliveryDate.text = dateFormatter.string(from: sender.date)
            deliveryDate = sender.date
        case 2002:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:MM"
            txtDeliveryTime.text = dateFormatter.string(from: sender.date)
            deliveryTime = sender.date
        default:
            break
        }
    }
}
