//
//  SettingDeliveryBoyTableViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 15/09/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import CoreLocation

class SettingDeliveryBoyTableViewController: UITableViewController {

    let KEYBOARD_ANIMATION_DURATION: CGFloat! = 0.3
    let MINIMUM_SCROLL_FRACTION: CGFloat! = 0.2
    let MAXIMUM_SCROLL_FRACTION: CGFloat! = 0.8
    var PORTRAIT_KEYBOARD_HEIGHT: CGFloat! = 216
    var animatedDistance: CGFloat!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var txtNoOfHours: UITextField!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var swtActive: UISwitch!
    @IBOutlet weak var swtWeekend: UISwitch!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var btnSave_erf: UIButton!
    @IBOutlet weak var lblCurrentRange: UILabel!
    
    var startTime = Date()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCustomization()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissView(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
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
        txtStartTime.inputAccessoryView = toolBar
        txtNoOfHours.inputAccessoryView = toolBar
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.separatorColor = UIColor.clear
        
        let width = CGFloat(1.0)
        let border = CALayer()
        border.borderColor = UIColor.init(red: 244.0 / 255.0, green: 244.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: txtNoOfHours.frame.size.height - width, width: txtNoOfHours.frame.size.width, height: txtNoOfHours.frame.size.height)
        border.borderWidth = width
        txtNoOfHours.layer.addSublayer(border)
        txtNoOfHours.layer.masksToBounds = true
        
        let border1 = CALayer()
        border1.borderColor = UIColor.init(red: 244.0 / 255.0, green: 244.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0).cgColor
        border1.frame = CGRect(x: 0, y: txtAddress.frame.size.height - width, width: txtAddress.frame.size.width, height: txtAddress.frame.size.height)
        border1.borderWidth = width
        txtAddress.layer.addSublayer(border1)
        txtAddress.layer.masksToBounds = true
        
        let border2 = CALayer()
        border2.borderColor = UIColor.init(red: 244.0 / 255.0, green: 244.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0).cgColor
        border2.frame = CGRect(x: 0, y: txtStartTime.frame.size.height - width, width: txtStartTime.frame.size.width, height: txtStartTime.frame.size.height)
        border2.borderWidth = width
        txtStartTime.layer.addSublayer(border2)
        txtStartTime.layer.masksToBounds = true
        
        let border3 = CALayer()
        border3.borderColor = UIColor.init(red: 244.0 / 255.0, green: 244.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0).cgColor
        border3.frame = CGRect(x: 0, y: txtCountry.frame.size.height - width, width: txtCountry.frame.size.width, height: txtCountry.frame.size.height)
        border3.borderWidth = width
        txtCountry.layer.addSublayer(border3)
        txtCountry.layer.masksToBounds = true
        
        let border4 = CALayer()
        border4.borderColor = UIColor.init(red: 244.0 / 255.0, green: 244.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0).cgColor
        border4.frame = CGRect(x: 0, y: txtCity.frame.size.height - width, width: txtCity.frame.size.width, height: txtCity.frame.size.height)
        border4.borderWidth = width
        txtCity.layer.addSublayer(border4)
        txtCity.layer.masksToBounds = true
        locationManager.delegate = self
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
        getDetailsFromServer()
    }
    
    func viewCustomization(){
        self.title = "Setting"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        //  self.tblTransactions.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
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

    @IBAction func sliderValueChange(_ sender: UISlider) {
        lblCurrentRange.text = String(Int(sender.value))
    }
    
    @IBAction func btnSave_Action(_ sender: UIButton) {
        saveDetailsFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 9
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingDeliveryBoyTableViewController : UITextFieldDelegate{
    //MARK:- UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtStartTime{
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .time
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            datePickerView.tag = 2001
        }
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
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        
        //  textfieldjobdate.text = dateFormatter.string(from: sender.date)
        switch sender.tag {
        case 2001:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            txtStartTime.text = dateFormatter.string(from: sender.date)
            startTime = sender.date
        default:
            break
        }
    }
}

extension SettingDeliveryBoyTableViewController{
    
    func getDetailsFromServer()  {
        NetworkHelper.get(url: Path.deliveryBoySetting, param: ["deliveryBoyId":UserManager.getDeliveryBoyId()], self, completionHandler: {[weak self] json, error in
            guard let `self` = self else { return }
            guard let json = json else {
                return
            }
            let response = json["response"][0].dictionaryValue
            if let weekDays = response["weekdayActive"]?.bool{
                self.swtActive.isOn = weekDays
            }
            if let weekend = response["weekendActive"]?.bool{
                 self.swtWeekend.isOn = weekend
            }
            if let startTime = response["startTime"]?.string{
                self.txtStartTime.text = OtherHelper.getTimeFromDateString(date: startTime)
            }
            if let totalHours = response["totalHours"]?.int{
                self.txtNoOfHours.text = String(totalHours)
            }
            if let distanceRange = response["distanceRange"]?.int{
                self.slider.setValue(Float(distanceRange), animated: true)
                self.lblCurrentRange.text = "\(distanceRange)"
            }
            if let address = response["address"]?.string{
                self.txtAddress.text = address
            }
            if let city = response["city"]?.string{
                self.txtCity.text = city
            }
            if let country = response["country"]?.string{
                self.txtCountry.text = country
            }
        })
    }
    
    func saveDetailsFromServer()  {
        NetworkHelper.put(url: Path.deliveryBoySetting, param: ["address":txtAddress.text ?? "", "city":txtCity.text ?? "", "userId" : UserManager.getUserId(), "country": txtCountry.text ?? "", "distanceRange": lblCurrentRange.text!,"weekdayActive" : swtActive.isOn, "weekendActive": swtWeekend.isOn, "totalHours": txtNoOfHours.text ?? "", "startTime": OtherHelper.getISOString(date: startTime), "_id" : UserManager.getDeliveryBoyId()], self, completionHandler: {[weak self] json, error in
            guard self != nil else { return }
            guard let json = json else {
                return
            }
            self?.view.endEditing(true)
            print(json)
            OtherHelper.simpleDialog("Success", "Setting Update Successfully", self!)
           self?.getDetailsFromServer()
        })
    }
    
}

extension SettingDeliveryBoyTableViewController: CLLocationManagerDelegate{
    
    // MARK: - CLLocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locatiobValue = manager.location?.coordinate{
            locationManager.stopUpdatingLocation()
            print("locations = \(locatiobValue.latitude) \(locatiobValue.longitude)")
            UserManager.setUserLatitude(token: locatiobValue.latitude)
            UserManager.setUserLongitude(token: locatiobValue.longitude)
            getAddressFromLatLon(pdblLatitude: String(locatiobValue.latitude), withLongitude: String(locatiobValue.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var address: [String:Any] = [:]
                    var addressString : String = ""
                    if pm.name != nil{
                        address["name"] = pm.name
                        addressString = addressString + pm.name! + ", "
                    }
                    if pm.subLocality != nil {
                        address["sub_locality"] = pm.subLocality!
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        address["state"] = pm.locality!
                        addressString = addressString + pm.locality! + ", "
                        self.txtCity.text = pm.locality ?? ""
                    }
                    if pm.country != nil {
                        address["country"] = pm.country!
                        addressString = addressString + pm.country! + ", "
                        self.txtCountry.text = pm.country ?? ""
                    }
                    if pm.postalCode != nil {
                        address["postal_code"] = pm.postalCode!
                        addressString = addressString + pm.postalCode! + " "
                    }
                    address ["full_address"] =  addressString
                    print(addressString)
                    UserDefaults.standard.set(address, forKey: AppConstant.currentUserLocation)
                    UserDefaults.standard.set(true, forKey: AppConstant.isCurrentLocationSaved)
                    self.txtAddress.text = addressString
                  
                    //self.dismiss(animated: true, completion: nil)
                }
        })
    }
}
