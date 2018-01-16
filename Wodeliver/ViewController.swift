//
//  ViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 15/12/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    var userTypePicker: UIPickerView!
    let userTypePickerValues = ["Store Front", "Customer", "Delivery Boy"]

    
    @IBOutlet weak var segmentView: MySegmentedControl!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var nameTextField: FloatLabelTextField!
    @IBOutlet weak var emailTextField: FloatLabelTextField!
    @IBOutlet weak var passwordTextField: FloatLabelTextField!
    @IBOutlet weak var redBackgroundView: UIView!
    @IBOutlet weak var registrationTypeTextField: FloatLabelTextField!
    var selectedUserType:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewCustomization()
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: .UIKeyboardDidShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: .UIKeyboardDidHide , object: nil)
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
    
    func viewCustomization(){
        userTypePicker = UIPickerView()
        userTypePicker.dataSource = self
        userTypePicker.delegate = self
        userTypePicker.backgroundColor = .white
        registrationTypeTextField.inputView = userTypePicker
        self.segmentView.selectedSegmentIndex = 1
        self.redBackgroundView.backgroundColor = Colors.redBackgroundColor
        self.shadowView.backgroundColor = UIColor.white
        self.segmentView.addTarget(self, action: #selector(changeSegmentValue(sender:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.view.addGestureRecognizer(tapGesture)
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
       self.view.endEditing(true)
    }
    @IBAction func btnSignUpAction(_ sender: Any) {
        self.view.endEditing(false)
        if self.isValidate() {
            let params :[String : Any] = ["name":nameTextField.text!,"email":emailTextField.text!,"password":passwordTextField.text!,"accountType": selectedUserType,"phone":""]
            self.userSignUp(param: params)
        }
    }
    
    @objc func changeSegmentValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            let strBoard = UIStoryboard(name: "Main", bundle: nil)
            let logInViewController = strBoard.instantiateViewController(withIdentifier: "LoginViewController")
            logInViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            self.present(logInViewController, animated: true, completion: nil)
          //  self.performSegue(withIdentifier: "signUpToLogin", sender: nil)
        case 1: break
           // self.performSegue(withIdentifier: "loginToSignup", sender: nil)
        default: break
        }
    }
    /**
     * Function to use for Validate data provoded by user
     * @param
     **/
    func isValidate() -> Bool  {
        self.view.endEditing(true)
        if self.nameTextField.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.userNameValidation, self)
            return false
        }
        else if self.emailTextField.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.userEmailEmpety, self)
            return false
        }
        else if self.emailTextField.text?.isValidateEmail() == false {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.userEmailValidation, self)
            return false
        }
        else if self.passwordTextField.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.passwordEmpety, self)
            return false
        }
        else if self.selectedUserType == 0{
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.userTypeSelection, self)
            return false
        }
        return true
    }
    func userSignUp(param : [String : Any]){
        ProgressBar.showActivityIndicator(view: self.view, withOpaqueOverlay: true)
        NetworkHelper.post(url: Path.signUpURL, param: param, self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard (json != nil) else {
                return
            }
            ProgressBar.hideActivityIndicator(view: self.view)
            print(json!)
            UserManager.setUserDetail(detail: json!["userData"])
            if UserManager.getUserType() == .storeManager{
                let strBoard = UIStoryboard(name: "StoreFront", bundle: nil)
                let logInViewController = strBoard.instantiateViewController(withIdentifier: "StoreFronTTabBarController")
                //logInViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
                self.present(logInViewController, animated: true, completion: nil)
            }else if UserManager.getUserType() == .deliveryBoy{
                self.performSegue(withIdentifier: "loginToTabbar", sender: nil)
            }else{
                OtherHelper.simpleDialog("Error", "Coming soon", self)
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
}
extension ViewController: UITextFieldDelegate{
    //MARK:- UITextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTextField
        {
            emailTextField.becomeFirstResponder()
        }
        else if textField == emailTextField
        {
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField
        {
            registrationTypeTextField.becomeFirstResponder()
        }else if textField == registrationTypeTextField
        {
            
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
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return UserTypeString.count.hashValue
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return UserTypeString(rawValue: row + 1 )?.description;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        registrationTypeTextField.text = UserTypeString(rawValue: row + 1)?.description
        selectedUserType =  row + 1
        self.view.endEditing(true)
    }

}


