//
//  AddItemViewController.swift
//  Wodeliver
//
//  Created by Roshani Singh on 13/03/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    var pickerView : UIPickerView!
    var pickOption = ["one", "two", "three", "seven", "fifteen"]
    @IBOutlet weak var itemImageBiew: UIImageView!
    @IBOutlet weak var itemTF: FloatLabelTextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPicker()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        categoryTF.inputAccessoryView = toolBar

    }
   @objc func doneClick() {
        categoryTF.resignFirstResponder()
    }
    @objc func cancelClick() {
        categoryTF.resignFirstResponder()
    }
    @IBAction func doneButtonAction(_ sender: Any) {
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
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
        return pickOption[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTF.text = pickOption[row]
    }
}
