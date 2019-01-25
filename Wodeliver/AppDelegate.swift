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
import Firebase
import UserNotifications
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, MessagingDelegate {
    
    var locationManager = CLLocationManager()
    var window: UIWindow?
    var hockeySDKIsSetup = false;
    var  clLocationCoordinate: CLLocationCoordinate2D?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey(GooglePlace.googlePlaceKey)
        GMSServices.provideAPIKey(GooglePlace.googleAPIKey)
        STPPaymentConfiguration.shared().publishableKey = StripeCredential.publishableKey
        STPPaymentConfiguration.shared().appleMerchantIdentifier = StripeCredential.appleMerchantId
        if UserManager.checkIfLogin(){
            if UserManager.getUserType() == .storeManager{
                let strBoard = UIStoryboard(name: "StoreFront", bundle: nil)
                let logInViewController = strBoard.instantiateViewController(withIdentifier: "StoreFronTTabBarController")
                logInViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
                //self.present(logInViewController, animated: true, completion: nil)
                self.window?.rootViewController = logInViewController
            }else if UserManager.getUserType() == .deliveryBoy{
                let strBoard = UIStoryboard(name: "Main", bundle: nil)
                let logInViewController = strBoard.instantiateViewController(withIdentifier: "TabBarController")
                logInViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
                //self.present(logInViewController, animated: true, completion: nil)
                self.window?.rootViewController = logInViewController
            }
        }
        if !hockeySDKIsSetup {
            BITHockeyManager.shared().configure(withIdentifier: HockeyKeys.appId)
            BITHockeyManager.shared().start()
            BITHockeyManager.shared().crashManager.crashManagerStatus = BITCrashManagerStatus.autoSend
            hockeySDKIsSetup = true;
        }
        FirebaseApp.configure()
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound], completionHandler: { granted, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard granted else { return }
                self.getNotificationSettings()
            })
            //UNUserNotificationCenter.current().delegate = self
        }else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
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
    
    // MARK: - Get Device Token for Push Notification
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        if deviceTokenString != UserManager.getDeviceToken(){
            if UserManager.checkIfLogin() {
                Messaging.messaging().apnsToken = deviceToken
                UserManager.setDeviceToken(token: deviceTokenString)
//                InstanceID.instanceID().instanceID { (result, error) in
//                    if let error = error {
//                        print("Error fetching remote instange ID: \(error)")
//                    } else if let result = result {
//                        print("Remote instance ID token: \(result.token)")
//                        self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
//                    }
//                }
            }else {
                UserManager.setDeviceToken(token: deviceTokenString)
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    // MARK: - failed to register fot push Notification
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    @available(iOS 10.0, *)
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
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

