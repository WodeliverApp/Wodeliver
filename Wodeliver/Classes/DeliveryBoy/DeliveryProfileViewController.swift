//
//  DeliveryProfileViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 06/08/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class DeliveryProfileViewController: UIViewController {

    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var imgProfile: WodeliverImageView!
    @IBOutlet weak var btnSave_ref: UIButton!
    @IBOutlet weak var btnBank_ref: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPhonePrefix: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtEmail: FloatLabelTextField!
    @IBOutlet weak var txtFullName: FloatLabelTextField!
    var profile : JSON!
    var isImage : Bool = false
    //MARK:- UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endViewEditing(_:)))
        self.view.addGestureRecognizer(tapGesture)
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage(_:)))
        imgProfile.addGestureRecognizer(imageGesture)
        imgProfile.isUserInteractionEnabled = true
        imagePicker.delegate = self
        imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        imgProfile.layer.borderWidth = 1.0
       
        getInfoFromServer(id: UserManager.getUserDetail()["_id"].stringValue)
        txtEmail.isEnabled = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.upperView.backgroundColor = UIColor.white
        self.innerView.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: .UIKeyboardDidHide, object: nil)
        self.title = "My"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
      //  self.view.backgroundColor = Colors.redBackgroundColor
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }

    @objc func keyboardDidShow(_ notification: NSNotification) {
        let keyboardSize: CGSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        PORTRAIT_KEYBOARD_HEIGHT = min(keyboardSize.height, keyboardSize.width)
    }

    @objc func keyboardDidHide(_ notification: NSNotification){}

    @objc func endViewEditing(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func chooseImage(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message:nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let TakePhoto = UIAlertAction(title: "Take Photo".localized, style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        let ChoosePhoto = UIAlertAction(title: "Choose from gallery".localized, style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.cancel)
        alertController.addAction(TakePhoto)
        alertController.addAction(ChoosePhoto)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- UIButton Methods
    
    @IBAction func btnSave_Action(_ sender: Any) {
        if (txtFullName.text?.count)! == 0 || (txtCountry.text?.count)! == 0 || (txtCity.text?.count)! == 0 || (txtAddress.text?.count)! == 0 || (txtPhonePrefix.text?.count)! == 0 || (txtPhone.text?.count)! == 0 {
            OtherHelper.simpleDialog("Error", "All fields are required", self)
            return
        }
        let imgBase64 = OtherHelper.convertImageToBase64(image: self.imgProfile.image!)
      //    let param = ["name": txtFullName.text ?? "", "city":txtCity.text ?? "", "country": txtCountry.text ?? "", "phone": txtPhone.text ?? "","address":txtAddress.text ?? "", "_id": UserManager.getUserId()] as [String : Any]
        let param = ["name": txtFullName.text ?? "", "city":txtCity.text ?? "", "country": txtCountry.text ?? "", "phone": txtPhone.text ?? "","address":txtAddress.text ?? "", "image": imgBase64, "_id": UserManager.getUserId()] as [String : Any]
        saveProfile(param: param)
    }
    
    @IBAction func btnBankDetails_Action(_ sender: Any) {
        
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

extension DeliveryProfileViewController: UITextFieldDelegate {

    //MARK:- UITextField Delegate Methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == emailTextField
//        {
//            passwordTextField.becomeFirstResponder()
//        }else if textField == passwordTextField
//        {
//            passwordTextField.resignFirstResponder()
//        }
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

extension DeliveryProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                UIImageJPEGRepresentation(pickedImage, 0.5)
                self.imgProfile.image = pickedImage
                self.isImage = true
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension DeliveryProfileViewController{
    func getInfoFromServer(id : String){
        NetworkHelper.get(url: "\(Path.baseURL)deliveryBoy/personalInfo", param: ["userId":id], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            self.setValues(profileInfo: json["response"][0])
           
        })
    }

    func setValues(profileInfo: JSON){
        UserManager.setDeliveryBoyProfile(detail: profileInfo)
        self.profile = UserManager.getDeliveryBoyProfile()
        txtFullName.text = profileInfo["name"].stringValue
        txtEmail.text = profileInfo["email"].stringValue
        imgProfile.sd_setImage(with: URL(string:Path.baseURL + profileInfo["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
        txtPhone.text = profileInfo["phone"].stringValue
        if let address = profileInfo["address"].array{
            txtCountry.text = address.first!["country"].stringValue
            txtAddress.text = address.first!["address"].stringValue
            txtCity.text = address.first!["city"].stringValue
        }
    }
    
    func saveProfile(param : [String:Any])  {
        NetworkHelper.put(url: "\(Path.baseURL)deliveryBoy/personalInfo", param: param, self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard (json != nil) else {
                return
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name.init("refreshBannerData"), object: nil, userInfo: nil)
                OtherHelper.buttonDialog("Success", "Profile Info Updated Successfully", self, "OK", false, completionHandler: {
                   self.getInfoFromServer(id: UserManager.getUserDetail()["_id"].stringValue)
                })
            }
        })
    }
}
