//
//  LoginViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/21/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    
    @IBOutlet weak var segmentView: MySegmentedControl!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var emailTextField: FloatLabelTextField!
    @IBOutlet weak var passwordTextField: FloatLabelTextField!
    @IBOutlet weak var redBackgroundView: UIView!
    @IBOutlet weak var btnLogin_ref : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewCustomization()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewCustomization(){
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.segmentView.selectedSegmentIndex = 0
        self.redBackgroundView.backgroundColor = Colors.redBackgroundColor
        self.shadowView.backgroundColor = UIColor.white
        self.segmentView.addTarget(self, action: #selector(changeSegmentValue(sender:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    func isValidate() -> Bool  {
        if self.emailTextField.text?.isEmpty == true {
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
        else if (self.passwordTextField.text?.count)! < 6 {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.passwordLentValidation, self)
            return false
        }
        return true
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        // self.performSegue(withIdentifier: "loginToTabbar", sender: nil)
        self.view.endEditing(true)
        if self.isValidate() {
            let params = ["email":emailTextField.text!,"password":passwordTextField.text!,"device":String(describing: DeviceType.iOS)]
            self.userLogin(param: params)
        }
    }
    
    func userLogin(param : [String : String]){
        ProgressBar.showActivityIndicator(view: self.view, withOpaqueOverlay: true)
        NetworkHelper.post(url: Path.loginURL, param: param, self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard (json != nil) else {
                self.btnLogin_ref.isEnabled = true
                return
            }
            ProgressBar.hideActivityIndicator(view: self.view)
            print(json!)
            UserManager.setUserDetail(detail: json!["userData"])
            
            let strBoard = UIStoryboard(name: "StoreFront", bundle: nil)
            let logInViewController = strBoard.instantiateViewController(withIdentifier: "StoreFronTTabBarController")
            logInViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            self.present(logInViewController, animated: true, completion: nil)
        })
    }
    
    @objc func changeSegmentValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: break
        //  self.performSegue(withIdentifier: "signUpToLogin", sender: nil)
        case 1:
            let strBoard = UIStoryboard(name: "Main", bundle: nil)
            let logInViewController = strBoard.instantiateViewController(withIdentifier: "ViewController")
            logInViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            self.present(logInViewController, animated: true, completion: nil)
        default: break
        }
    }
}
extension LoginViewController: UITextFieldDelegate{
    
    //MARK:- UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField
        {
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField
        {
            passwordTextField.resignFirstResponder()
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
