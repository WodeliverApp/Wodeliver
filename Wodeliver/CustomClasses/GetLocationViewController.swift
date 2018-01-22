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

class GetLocationViewController: UIViewController , CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    var googlePlace : GMSPlace!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        self.locationManager.requestWhenInUseAuthorization()
        //        if CLLocationManager.locationServicesEnabled() {
        //            locationManager.delegate = self
        //            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //            locationManager.startUpdatingLocation()
        //        }
    }
    
    // MARK: - CLLocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        getAddressFromLatLon(pdblLatitude: String(locValue.latitude), withLongitude: String(locValue.longitude))
        // print(addressString)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @IBAction func btnDetectMyLocation_Action(_ sender: Any) {
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
//            locationManager.stopUpdatingLocation()
        }
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
                //  print("Type: \(field.type), Name: \(field.name)")
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    // street_number = field.name
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
        UserDefaults.standard.set(address, forKey: AppConstant.currentUserLocation)
        UserDefaults.standard.set(true, forKey: AppConstant.isCurrentLocationSaved)
        dismiss(animated: true, completion: nil)
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