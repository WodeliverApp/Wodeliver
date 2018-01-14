//
//  StoreProfileViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class StoreProfileViewController: UIViewController {

    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtTelephone: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissView(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension StoreProfileViewController: UITextFieldDelegate{
    //MARK:- UITextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtCategory
        {
            txtName.becomeFirstResponder()
        }else if textField == txtName
        {
            txtAddress.becomeFirstResponder()
        }else if textField == txtAddress
        {
            txtCity.becomeFirstResponder()
        }else if textField == txtCity
        {
            txtCountry.becomeFirstResponder()
        }else if textField == txtCountry
        {
            txtTelephone.becomeFirstResponder()
        }
        else if textField == txtTelephone
        {
            txtDescription.becomeFirstResponder()
        }else if textField == txtDescription
        {
            txtDescription.resignFirstResponder()
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
