//
//  AddHotspotViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 26/03/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class AddHotspotViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var txtStartDate: FloatLabelTextField!
    @IBOutlet weak var txtEndDate: FloatLabelTextField!
    @IBOutlet weak var txtStartTime: FloatLabelTextField!
    @IBOutlet weak var txtEndTime: FloatLabelTextField!
    @IBOutlet weak var txtLocation: FloatLabelTextField!
    @IBOutlet weak var txtStoreItem: FloatLabelTextField!
    @IBOutlet weak var btnDone_ref: UIButton!
    @IBOutlet weak var btnClose_ref: UIButton!
    @IBOutlet weak var hotSpotImageView: UIImageView!
    
    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    var imagePicker = UIImagePickerController()
    var isItemImg: Bool = false
    var pickerView : UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.createPicker()
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
        txtEndDate.inputAccessoryView = toolBar
        txtStartTime.inputAccessoryView = toolBar
        txtEndTime.inputAccessoryView = toolBar
        txtLocation.inputAccessoryView = toolBar
        txtStoreItem.inputAccessoryView = toolBar
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(self.imagePicker(_:)))
        hotSpotImageView.addGestureRecognizer(imageGesture)
        hotSpotImageView.isUserInteractionEnabled = true
        imagePicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIToolBar Button Actions
    
    @objc func doneClick() {
        self.view.endEditing(true)
    }
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        
        //  textfieldjobdate.text = dateFormatter.string(from: sender.date)
        switch sender.tag {
        case 2001:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            txtStartDate.text = dateFormatter.string(from: sender.date)
       /* case 2002:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            txtEndDate.text = dateFormatter.string(from: sender.date)
        case 2004:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            txtEndTime.text = dateFormatter.string(from: sender.date)
        case 2003:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            txtStartTime.text = dateFormatter.string(from: sender.date)
       */
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

    // MARK: - UIButton Action
    
    @IBAction func btnDone_Action(_ sender: Any) {
        self.view.endEditing(true)
        if self.isValidate() {
        }
    }
    
    @IBAction func btnClose_Action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Validation All Field
    
    func isValidate() -> Bool  {
        if self.txtStartDate.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.itemValidation, self)
            return false
        }
        /*else if self.txtEndDate.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.itemPriceValidation, self)
            return false
        }
        else if self.txtEndTime.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.itemDescValidation, self)
            return false
        }*/
        else if self.txtStartTime.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.itemCatValidation, self)
            return false
        }
      
        else if self.txtLocation.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.itemDescValidation, self)
            return false
        }
        else if (self.isItemImg != true){
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.itemImgValidation, self)
            return false
        }
        return true
    }
    
    //MARK:- Server Action
    
    func getAvailableTimeSlot(param : [String : Any]){
        NetworkHelper.get(url: Path.getTimeSlot, param: param, self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard (json != nil) else {
                return
            }
        
            let jsonDict = json?.dictionaryValue
            var arr = [String]()
          
            for (key, value) in jsonDict! {
                arr.append("\(key) \(value)")
            }
            print(arr)
//            let dict : String = (json?.stringValue)!
//            let myData = dict.split(separator: ",")
            //print(myData)
            print(arr[0])
        })
    }
    
    func saveItem(param : [String : Any]){
        NetworkHelper.post(url: Path.addHotSpotItem, param: param, self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard (json != nil) else {
                return
            }
            //print(json)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name.init("refreshItemData"), object: nil, userInfo: nil)
                self.dismiss(animated: true, completion: nil)
            }
        })
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
extension AddHotspotViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.hotSpotImageView.image = pickedImage
                self.isItemImg = true
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
extension AddHotspotViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1001:
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            datePickerView.tag = 2001
      /*  case 1002:
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            datePickerView.tag = 2002
        case 1004:
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .time
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            datePickerView.tag = 2004
        case 1003:
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .time
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            datePickerView.tag = 2003
        */
        default:
            break
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1001:
            let param = ["slotFor":"1", "date":textField.text!] as [String : Any]
            self.getAvailableTimeSlot(param: param)
        default:
            break
        }
    }
}
extension AddHotspotViewController{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //  return pickOption.count
        return 10
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // return pickOption[row]["name"].stringValue
        return "Test"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        txtLocation.text = pickOption[row]["name"].stringValue
        //        selectedItemCategory = pickOption[row]["_id"].stringValue
    }
}
