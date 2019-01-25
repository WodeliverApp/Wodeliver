//
//  AddBannerViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 26/03/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class AddBannerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, TimeSlotProtocol {
    

    @IBOutlet weak var txtStartDate: FloatLabelTextField!
    @IBOutlet weak var txtStartTime: FloatLabelTextField!
    @IBOutlet weak var txtLocation: FloatLabelTextField!
    @IBOutlet weak var txtPrice: FloatLabelTextField!
    @IBOutlet weak var btnDone_ref: UIButton!
    @IBOutlet weak var btnClose_ref: UIButton!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    var imagePicker = UIImagePickerController()
    var isItemImg: Bool = false
    var pickerView : UIPickerView!
    var locationList : [[String : String]] = [["id": "0","name":"Home"],["id": "1","name":"Store Category"],["id": "2","name":"Store Search Result"]]
    var selectedSlotIds = [String]()
    var selectedSlotIdInt = [Int]()
    var selectedLocationId : String = ""
    var startDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissView(_:)))
        self.view.addGestureRecognizer(tapGesture)
        self.createPicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Create Picker
    
    func createPicker(){
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.white
        txtLocation.inputView = self.pickerView
        
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
        txtStartDate.inputAccessoryView = toolBar
        txtLocation.inputAccessoryView = toolBar
        txtPrice.inputAccessoryView = toolBar
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(self.imagePicker(_:)))
        bannerImageView.addGestureRecognizer(imageGesture)
        bannerImageView.isUserInteractionEnabled = true
        imagePicker.delegate = self
    }
    
    //MARK:- UIDatePicker Actions
    
    @IBAction func dp(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        
      //  textfieldjobdate.text = dateFormatter.string(from: sender.date)
        switch sender.tag {
        case 2001:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            txtStartDate.text = dateFormatter.string(from: sender.date)
            startDate = sender.date
        default:
            break
        }
    }
    
    //MARK:- Camera Actions
    
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
    
    //MARK:- UIToolBar Button Actions
    
    @objc func doneClick() {
        self.view.endEditing(true)
    }
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - UIButton Action
    
    @IBAction func btnDone_Action(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.isValidate() {
            let imgBase64 = OtherHelper.convertImageToBase64(image: bannerImageView.image!)
            let param = ["date": OtherHelper.getISOString(date: startDate), "storeId": UserManager.getStoreId() ,"slot": selectedSlotIdInt, "location": selectedLocationId, "image": imgBase64,"banner":"banner", "price":txtPrice.text ?? "","seqeunce":"1","slotFor":"1"] as [String : Any]
              print(["date": OtherHelper.getISOString(date: startDate), "storeId": UserManager.getStoreId() ,"slot": selectedSlotIdInt, "location": selectedLocationId, "image": "imgBase64","banner":"banner", "price":txtPrice.text ?? "","seqeunce":"1","slotFor":"1"])
            saveBanner(param: param)
        }
    }
    
    @IBAction func btnClose_Action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Validation All Field
    
    func isValidate() -> Bool  {
        if self.txtStartDate.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.startDateValidation, self)
            return false
        }
        else if self.txtStartTime.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.startTimeValidation, self)
            return false
        }
        else if self.txtLocation.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.locationValidation, self)
            return false
        }
        else if (self.isItemImg != true){
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.bannerImgValidation, self)
            return false
        }
        else if self.txtPrice.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.itemPriceValidation, self)
            return false
        }
        return true
    }
    
    //MARK:- Server Action
    
    func saveBanner(param : [String : Any]){
        NetworkHelper.post(url: Path.addBannner, param: param, self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard (json != nil) else {
                return
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name.init("refreshBannerData"), object: nil, userInfo: nil)
                OtherHelper.buttonDialog("Success", "Banner added Successfully", self, "OK", false, completionHandler: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
        })
    }
    
    // MARK: - Custom Delegate TimeSlotProtocol
    
    func setTimeSlots(selectedIds : [String], selectedTimes : [String], selectedIdsInt : [Int]) {
        txtStartTime.text = selectedTimes.map { String($0) }.joined(separator: ", ")
        selectedSlotIds = selectedIds
        selectedSlotIdInt = selectedIdsInt
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
extension AddBannerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                UIImageJPEGRepresentation(pickedImage, 0.5)
                self.bannerImageView.image = pickedImage
                self.isItemImg = true
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
extension AddBannerViewController{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locationList[row]["name"]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtLocation.text = locationList[row]["name"]
        selectedLocationId = locationList[row]["id"]!
    }
}
extension AddBannerViewController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1003:
            if self.txtStartDate.text?.isEmpty == true {
                OtherHelper.simpleDialog("Validation Fails", AlertMessages.startDateValidation, self)
            }else{
                let storyboard : UIStoryboard = UIStoryboard(name: "StoreFront", bundle: nil)
                let viewController : TimeSlotViewController = storyboard.instantiateViewController(withIdentifier: "TimeSlotViewController") as! TimeSlotViewController
                viewController.startDate = startDate
                viewController.modalPresentationStyle = .overFullScreen
                viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                viewController.isHotSpotItem = true
                viewController.delegate = self
                self.present(viewController, animated: false, completion: nil)
            }
            return false
        default:
            break
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
        case 1001:
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            datePickerView.tag = 2001
        case 1002:
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
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
    
}
