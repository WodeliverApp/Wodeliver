//
//  AppDelegate.swift
//  Wodeliver
//
//  Created by Anuj Singh on 15/12/17.
//  Copyright © 2017 Anuj Singh. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import GooglePlaces
import GoogleMaps
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var window: UIWindow?
    var hockeySDKIsSetup = false;
    var  clLocationCoordinate: CLLocationCoordinate2D?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey(GooglePlace.googlePlaceKey)
        GMSServices.provideAPIKey(GooglePlace.googleAPIKey)
        
        if !hockeySDKIsSetup {
            BITHockeyManager.shared().configure(withIdentifier: HockeyKeys.appId)
            BITHockeyManager.shared().start()
            BITHockeyManager.shared().crashManager.crashManagerStatus = BITCrashManagerStatus.autoSend
            hockeySDKIsSetup = true;
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if UserDefaults.standard.value(forKey: AppConstant.currentUserLocation) == nil{
            UserDefaults.standard.set(false, forKey: AppConstant.isCurrentLocationSaved)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    // MARK: - CLLocationManager Delegate
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
    //        print("locations = \(locValue.latitude) \(locValue.longitude)")
    //        getAddressFromLatLon(pdblLatitude: String(locValue.latitude), withLongitude: String(locValue.longitude))
    //       // print(addressString)
    //    }
    //
    //    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
    //        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
    //        let lat: Double = Double("\(pdblLatitude)")!
    //        //21.228124
    //        let lon: Double = Double("\(pdblLongitude)")!
    //        //72.833770
    //        let ceo: CLGeocoder = CLGeocoder()
    //        center.latitude = lat
    //        center.longitude = lon
    //
    //        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
    //
    //
    //        ceo.reverseGeocodeLocation(loc, completionHandler:
    //            {(placemarks, error) in
    //                if (error != nil)
    //                {
    //                    print("reverse geodcode fail: \(error!.localizedDescription)")
    //                }
    //                let pm = placemarks! as [CLPlacemark]
    //
    //                if pm.count > 0 {
    //                    let pm = placemarks![0]
    //                    print(pm.country)
    //                    print(pm.locality)
    //                    print(pm.subLocality)
    //                    print(pm.thoroughfare)
    //                    print(pm.postalCode)
    //                    print(pm.subThoroughfare)
    //                    var addressString : String = ""
    //                    if pm.subLocality != nil {
    //                        addressString = addressString + pm.subLocality! + ", "
    //                    }
    //                    if pm.thoroughfare != nil {
    //                        addressString = addressString + pm.thoroughfare! + ", "
    //                    }
    //                    if pm.locality != nil {
    //                        addressString = addressString + pm.locality! + ", "
    //                    }
    //                    if pm.country != nil {
    //                        addressString = addressString + pm.country! + ", "
    //                    }
    //                    if pm.postalCode != nil {
    //                        addressString = addressString + pm.postalCode! + " "
    //                    }
    //
    //
    //                    print(addressString)
    //                }
    //        })
    //
    //    }
}

