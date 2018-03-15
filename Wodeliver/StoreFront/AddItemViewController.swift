//
//  AddItemViewController.swift
//  Wodeliver
//
//  Created by Roshani Singh on 13/03/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    var pickerView : UIPickerView!
    var pickOption: [JSON] = []
    var imagePicker = UIImagePickerController()
    var isItemImg:Bool! = false
    var itemObject: [String: JSON]?
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTF: FloatLabelTextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPicker()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissView(_:)))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
        priceTF.delegate = self
        itemTF.delegate = self
        categoryTF.delegate = self
        descriptionTF.delegate = self
        self.getItemCategory()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    func updateUI(){
        if itemObject != nil{
            self.itemTF.text = itemObject!["item"]?.stringValue
            self.priceTF.text = itemObject!["price"]?.stringValue
        //  cell.lblProdcutCategory.text = item["item"].stringValue
            self.descriptionTF.text = itemObject!["description"]?.stringValue
            self.itemImageView.sd_setImage(with: URL(string:Path.baseURL + (itemObject!["image"]?.stringValue.replace(target: " ", withString: "%20"))!), placeholderImage: UIImage(named: "no_image"))
            self.isItemImg = true
        }
    }
    func createPicker(){
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.white
        categoryTF.inputView = self.pickerView
        
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
        categoryTF.inputAccessoryView = toolBar

        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(self.imagePicker(_:)))
        itemImageView.addGestureRecognizer(imageGesture)
        itemImageView.isUserInteractionEnabled = true
        imagePicker.delegate = self
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
    
   @objc func doneClick() {
        categoryTF.resignFirstResponder()
    }
    @objc func cancelClick() {
        categoryTF.resignFirstResponder()
    }
    @IBAction func doneButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if self.isValidate() {
            let imgBase64 = OtherHelper.convertImageToBase64(image: self.itemImageView.image!)
            let param = ["itemCategory": self.categoryTF.text ?? "", "category": "", "item": self.itemTF.text ?? "", "price": self.priceTF.text ?? "", "image": imgBase64, "member": "123", "description": self.descriptionTF.text ?? "", "storeId": UserManager.getStoreId()] as [String : Any]
            if itemObject != nil{
              self.updateItem(param: param)
            }else{
            self.saveItem(param: param)
            }
        }
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
    }
    func isValidate() -> Bool  {
        if self.itemTF.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.itemValidation, self)
            return false
        }
        else if self.priceTF.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.itemPriceValidation, self)
            return false
        }
        else if self.categoryTF.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.itemCatValidation, self)
            return false
        }
        else if self.descriptionTF.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.itemDescValidation, self)
            return false
        }
        else if (self.isItemImg != true){
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.itemImgValidation, self)
            return false
        }
        return true
    }
}
extension AddItemViewController: UITextFieldDelegate{
    
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
extension AddItemViewController{
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
        categoryTF.text = pickOption[row]["name"].stringValue
    }
}
extension AddItemViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.itemImageView.image = pickedImage
                self.isItemImg = true
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
extension AddItemViewController{

    func saveItem(param : [String : Any]){
        ProgressBar.showActivityIndicator(view: self.view, withOpaqueOverlay: true)
        NetworkHelper.post(url: Path.storeAddItem, param: param, self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard (json != nil) else {
                return
            }
            ProgressBar.hideActivityIndicator(view: self.view)
            print(json)
             self.dismiss(animated: true, completion: nil)
        })
    }
    func updateItem(param : [String : Any]){
        ProgressBar.showActivityIndicator(view: self.view, withOpaqueOverlay: true)
        NetworkHelper.put(url: Path.storeAddItem, param: param, self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard (json != nil) else {
                return
            }
            ProgressBar.hideActivityIndicator(view: self.view)
            print(json)
            self.dismiss(animated: true, completion: nil)
        })
    }
    //MARK: - Server Action
    
    func getItemCategory()  {
         ProgressBar.showActivityIndicator(view: self.view, withOpaqueOverlay: true)
        NetworkHelper.get(url: Path.categoryURL, param: [:], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            ProgressBar.hideActivityIndicator(view: self.view)
            self.pickOption = json["response"]["itemcategory"].arrayValue
            print(self.pickOption)
            self.pickerView.reloadAllComponents()
        })
    }
}
