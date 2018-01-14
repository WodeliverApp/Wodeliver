//
//  LoginViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/21/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var segmentView: MySegmentedControl!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var emailTextField: FloatLabelTextField!
    @IBOutlet weak var passwordTextField: FloatLabelTextField!
    @IBOutlet weak var redBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewCustomization()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
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
    @IBAction func btnLoginAction(_ sender: Any) {
       // self.performSegue(withIdentifier: "loginToTabbar", sender: nil)
        
        let strBoard = UIStoryboard(name: "StoreFront", bundle: nil)
        let logInViewController = strBoard.instantiateViewController(withIdentifier: "StoreFronTTabBarController")
        logInViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.present(logInViewController, animated: true, completion: nil)
        
    
        
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
        animateViewMoving(up: true, moveValue: 100)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
