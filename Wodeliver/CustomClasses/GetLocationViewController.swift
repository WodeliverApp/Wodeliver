//
//  GetLocationViewController.swift
//  Wodeliver
//
//  Created by Anuj Singh on 22/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps

class GetLocationViewController: UIViewController , CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    var googlePlace : GMSPlace!
    var placesClient: GMSPlacesClient!
    @IBOutlet weak var doneNavigation_ref: UIBarButtonItem!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblAddressDetails: UILabel!
    @IBOutlet weak var btnUseMyLocation_ref: UIButton!
    @IBOutlet weak var btnPickAddress_ref: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPickAddress_ref.layer.cornerRadius = 5.0
        btnPickAddress_ref.clipsToBounds = true
        btnUseMyLocation_ref.layer.cornerRadius = 5.0
        btnUseMyLocation_ref.clipsToBounds  = true
        doneNavigation_ref.isEnabled = false
        self.viewCostomization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        placesClient = GMSPlacesClient.shared()
        
    }
    
    func viewCostomization(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.redBackgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = Colors.viewBackgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    @IBAction func btnDetectMyLocation_Action(_ sender: Any) {
        // For use in foreground
        
        //        if CLLocationManager.locationServicesEnabled() {
        //            locationManager.delegate = self
        //            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //            locationManager.startUpdatingLocation()
        ////            locationManager.stopUpdatingLocation()
        //        }
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                OtherHelper.simpleDialog("Error", error.localizedDescription, self)
                return
            }
            
            self.lblAddressDetails.text = "No current place"
            self.lblAddressDetails.text = ""
            
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.lblAddressDetails.text =  (place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: " "))!
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    @IBAction func btnUseMannual_Action(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
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
                        address["city"] = pm.locality!
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.administrativeArea != nil {
                        address["state"] = pm.administrativeArea!
                        addressString = addressString + pm.administrativeArea! + ", "
                    }
                    if pm.country != nil {
                        address["country"] = pm.country!
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        address["postal_code"] = pm.postalCode!
                        addressString = addressString + pm.postalCode! + " "
                    }
                    address ["full_address"] =  addressString
                    UserDefaults.standard.set(address, forKey: AppConstant.currentUserLocation)
                    UserDefaults.standard.set(true, forKey: AppConstant.isCurrentLocationSaved)
                    self.lblAddressDetails.text = addressString
                    self.doneNavigation_ref.isEnabled = true
                    //self.dismiss(animated: true, completion: nil)
                }
        })
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

extension GetLocationViewController : GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        var address: [String:Any] = [:]
        address["place_name"] = place.name
        googlePlace = place
        UserManager.setUserLatitude(token: place.coordinate.latitude)
        UserManager.setUserLongitude(token: place.coordinate.longitude)
        if let webSite = place.website {
            address["web_site"] = String(describing: webSite)
        }
        else{
            address["web_site"] = ""
        }
        // Get the address components.
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    address["stree_number"] = field.name
                    break
                case kGMSPlaceTypeRoute:
                    // route = field.name
                    break
                case kGMSPlaceTypeNeighborhood:
                    // neighborhood = field.name
                    break
                case kGMSPlaceTypeLocality:
                    address["city"] = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    address["state"] = field.name
                    
                case kGMSPlaceTypeCountry:
                    address["country"] = field.name
                case kGMSPlaceTypePostalCode:
                    address["postal_code"] = field.name
                case kGMSPlaceTypePostalCodeSuffix:
                    break
                // postal_code_suffix = field.name
                default:
                    //  print("Type: \(field.type), Name: \(field.name)")
                    break
                }
            }
        }
        address ["full_address"] =  googlePlace.formattedAddress
        UserDefaults.standard.set(address, forKey: AppConstant.currentUserLocation)
        UserDefaults.standard.set(true, forKey: AppConstant.isCurrentLocationSaved)
        lblAddressDetails.text = googlePlace.formattedAddress
        self.doneNavigation_ref.isEnabled = true
        dismiss(animated: false, completion: ({
            // self.dismiss(animated: true, completion: nil)
        }))
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
