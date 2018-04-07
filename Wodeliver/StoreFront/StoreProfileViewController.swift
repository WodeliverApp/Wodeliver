//
//  StoreProfileViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 12/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class StoreProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtTelephone: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    
    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    var imagePicker = UIImagePickerController()
    var isImage : Bool = false
    var pickerView : UIPickerView!
    var pickOption: [JSON] = []
    var selectedItemCategory : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissView(_:)))
        self.view.addGestureRecognizer(tapGesture)
        self.viewCostomization()
        
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(self.imagePicker(_:)))
        imgProfile.addGestureRecognizer(imageGesture)
        imgProfile.isUserInteractionEnabled = true
        imagePicker.delegate = self
        
        self.pickOption = UserManager.getCategory().arrayValue
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.white
        txtCategory.inputView = self.pickerView
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
        print("Keyboard will hide!")
    }
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBAction func setting_Action(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message:nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let logoutAction = UIAlertAction(title: "Logout".localized, style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            UserManager.logout(isDisable: true)
            
            let strBoard = UIStoryboard(name: "Main", bundle: nil)
            let logInViewController = strBoard.instantiateViewController(withIdentifier: "LoginViewController")
            logInViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            self.present(logInViewController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.cancel)
        alertController.addAction(logoutAction)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func imagePicker(_ sender: UITapGestureRecognizer) {
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

    func viewCostomization(){
        self.title = "My"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
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
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtCategory.inputAccessoryView = toolBar
        txtTelephone.inputAccessoryView = toolBar
    }
    
    //MARK:- UIToolBar Button Actions
    
    @objc func doneClick() {
        self.view.endEditing(true)
    }
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Validation All Field
    
    func isValidate() -> Bool  {
        if self.txtName.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.storeName, self)
            return false
        }
        else if self.txtCity.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.storeCity, self)
            return false
        }
        else if self.txtAddress.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.storeAddress, self)
            return false
        }
        else if self.txtCountry.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.storeCountry, self)
            return false
        }
        else if self.txtTelephone.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.storePhone, self)
            return false
        }
        else if self.txtDescription.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.storeDescription, self)
            return false
        }
        else if (self.isImage != true){
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.storeProfileImage, self)
            return false
        }
        return true
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
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

extension StoreProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.imgProfile.image = pickedImage
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
extension StoreProfileViewController{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]["name"].stringValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCategory.text = pickOption[row]["name"].stringValue
        selectedItemCategory = pickOption[row]["_id"].stringValue
    }
}
