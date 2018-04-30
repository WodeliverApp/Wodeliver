//
//  ForgotPasswordViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 15/02/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    
    @IBOutlet weak var navigation_ref: UINavigationBar!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var emailTextField: FloatLabelTextField!
    @IBOutlet weak var forgotPasswordButton : UIButton!
    //MARK:- UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewCustomization()
  
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: .UIKeyboardDidShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: .UIKeyboardDidHide , object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let bounds = navigation_ref.bounds
//        navigation_ref.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + 100)
//        let height: CGFloat = 50 //whatever height you want to add to the existing height
//        let bounds = self.navigationController!.navigationBar.bounds
//        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)

    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//       // let height = CGFloat(72)
//         let bounds = navigation_ref.bounds
//        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + 100)
//    }
//
    // Deinit All view element
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    
    //MARK:- UIKeyboard Notification
    
    @objc func keyboardDidShow(_ notification: NSNotification) {
        let keyboardSize:CGSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        PORTRAIT_KEYBOARD_HEIGHT = min(keyboardSize.height, keyboardSize.width)
    }
    
    @objc func keyboardDidHide(_ notification: NSNotification) {
        
    }
    
    //MARK:- Local Functions
    
    func viewCustomization(){
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.shadowView.backgroundColor = UIColor.white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.endViewEditing(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func endViewEditing(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnForgotAction(_ sender: Any) {
        self.view.endEditing(true)
        
        if self.isValidate() {
            let params = ["email":emailTextField.text!,"device":String(describing: DeviceType.iOS)]
            self.forgotPassword(param: params)
        }
    }
    
    
    func forgotPassword(param : [String : String]){
        NetworkHelper.post(url: Path.forgotPasswordURL, param: param, self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard (json != nil) else {
                self.forgotPasswordButton.isEnabled = true
                return
            }
           // print(json)
//            if UserManager.getUserType() == .storeManager{
//                let strBoard = UIStoryboard(name: "StoreFront", bundle: nil)
//                let logInViewController = strBoard.instantiateViewController(withIdentifier: "StoreFronTTabBarController")
//                logInViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
//                self.present(logInViewController, animated: true, completion: nil)
//            }else if UserManager.getUserType() == .deliveryBoy{
//                self.performSegue(withIdentifier: "loginToTabbar", sender: nil)
//            }else{
//                OtherHelper.simpleDialog("Error", "Coming soon", self)
//            }
            
        })
    }
  
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Validating UITextFiled
    
    func isValidate() -> Bool  {
        if self.emailTextField.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.userEmailEmpety, self)
            return false
        }
        else if self.emailTextField.text?.isValidateEmail() == false {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.userEmailValidation, self)
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

extension ForgotPasswordViewController: UITextFieldDelegate{
    
    //MARK:- UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
