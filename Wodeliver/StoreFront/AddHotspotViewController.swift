//
//  AddHotspotViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 26/03/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class AddHotspotViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, TimeSlotProtocol  {
    
    @IBOutlet weak var txtStartDate: FloatLabelTextField!
    @IBOutlet weak var txtStartTime: FloatLabelTextField!
    @IBOutlet weak var txtLocation: FloatLabelTextField!
    @IBOutlet weak var txtStoreItem: FloatLabelTextField!
    @IBOutlet weak var txtPrice: FloatLabelTextField!
    @IBOutlet weak var btnDone_ref: UIButton!
    @IBOutlet weak var btnClose_ref: UIButton!
    @IBOutlet weak var hotSpotImageView: UIImageView!
    
    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    var imagePicker = UIImagePickerController()
    var isItemImg: Bool = true
    var pickerView : UIPickerView!
    var itemListPicker : UIPickerView!
    var selectedSlotIds = [String]()
    var locationList : [[String : String]] = [["id": "0","name":"Home"],["id": "1","name":"Store Category"],["id": "2","name":"Store Search Result"]]
    var selectedLocationId : String = ""
    var storeItemList : [JSON] = []
    var selectedStoreItem : String = ""
    var startDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.createPicker()
        self.storeItemList = UserManager.getStoreItemList().arrayValue
    }
    
    //MARK:- Create Picker
    
    func createPicker(){
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.white
        pickerView.tag = 5001
        txtLocation.inputView = pickerView
        
        itemListPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        itemListPicker.delegate = self
        itemListPicker.dataSource = self
        itemListPicker.backgroundColor = UIColor.white
        itemListPicker.tag = 5003
        txtStoreItem.inputView = itemListPicker
        
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
        txtStoreItem.inputAccessoryView = toolBar
        txtPrice.inputAccessoryView = toolBar
        //        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(self.imagePicker(_:)))
        //        hotSpotImageView.addGestureRecognizer(imageGesture)
        //        hotSpotImageView.isUserInteractionEnabled = true
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
        switch sender.tag {
        case 2001:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
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
    
    // MARK: - UIButton Action
    
    @IBAction func btnDone_Action(_ sender: Any) {
        self.view.endEditing(true)
        if self.isValidate() {
            //  let imgBase64 = OtherHelper.convertImageToBase64(image: self.hotSpotImageView.image!)
            var iso8601String : String = ""
            if #available(iOS 10.0, *) {
                let dateFormatter = ISO8601DateFormatter()
                iso8601String = dateFormatter.string(from: startDate)
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                iso8601String = dateFormatter.string(from: startDate)
                print(iso8601String)
            }
            print(iso8601String)
            
            let param = ["date": iso8601String, "storeId": UserManager.getStoreId() ,"slot": selectedSlotIds, "location": selectedLocationId,"slotFor":"2","hotspotItems": [selectedStoreItem]] as [String : Any]
            saveHotSpotItem(param: param)
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
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.startDateValidation, self)
            return false
        }
            
        else if self.txtLocation.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.hotSpotLocationValidation, self)
            return false
        }
        else if (self.isItemImg != true){
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.hotspotImgValidation, self)
            return false
        }
        else if self.txtPrice.text?.isEmpty == true {
            OtherHelper.simpleDialog("Validation Fails", AlertMessages.itemPriceValidation, self)
            return false
        }
        return true
    }
    
    //MARK:- Server Action
    
    func saveHotSpotItem(param : [String : Any]){
        NetworkHelper.post(url: Path.addHotSpotItem, param: param, self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard (json != nil) else {
                return
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name.init("refreshHotSpotData"), object: nil, userInfo: nil)
                OtherHelper.buttonDialog("Success", "Hotspot Item added Successfully", self, "OK", false, completionHandler: {
                    self.dismiss(animated: true, completion: nil)
                    })
            }
        })
    }
    
    
    // MARK: - Custom Delegate TimeSlotProtocol
    
    func setTimeSlots(selectedIds : [String], selectedTimes : [String]) {
        txtStartTime.text = selectedTimes.map { String($0) }.joined(separator: ", ")
        selectedSlotIds = selectedIds
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
extension AddHotspotViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                UIImageJPEGRepresentation(pickedImage, 0.5)
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1003:
            if self.txtStartDate.text?.isEmpty == true {
                OtherHelper.simpleDialog("Validation Fails", AlertMessages.startDateValidation, self)
            }else{
                let storyboard : UIStoryboard = UIStoryboard(name: "StoreFront", bundle: nil)
                let viewController : TimeSlotViewController = storyboard.instantiateViewController(withIdentifier: "TimeSlotViewController") as! TimeSlotViewController
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
        switch textField.tag {
        case 1001:
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            datePickerView.tag = 2001
        case 1003:
            let storyboard : UIStoryboard = UIStoryboard(name: "StoreFront", bundle: nil)
            let viewController : TimeSlotViewController = storyboard.instantiateViewController(withIdentifier: "TimeSlotViewController") as! TimeSlotViewController
            viewController.modalPresentationStyle = .overFullScreen
            viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            viewController.isHotSpotItem = true
            viewController.delegate = self
            self.present(viewController, animated: false, completion: nil)
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
            //            let param = ["slotFor":"2", "date":textField.text!] as [String : Any]
            //         //   self.getAvailableTimeSlot(param: param)
            break
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
        if pickerView.tag == 5001{
            return locationList.count
        }else{
            return storeItemList.count
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 5001{
            return locationList[row]["name"]
        }else{
            return storeItemList[row]["item"].stringValue
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 5001{
            txtLocation.text = locationList[row]["name"]
            selectedLocationId = locationList[row]["id"]!
        }else{
            txtStoreItem.text = storeItemList[row]["item"].stringValue
            selectedStoreItem = storeItemList[row]["_id"].stringValue
            // if !isItemImg{
            hotSpotImageView.sd_setImage(with: URL(string:Path.baseURL + storeItemList[row]["image"].stringValue.replace(target: " ", withString: "%20")), placeholderImage: UIImage(named: "no_image"))
            //}
        }
        
    }
}
