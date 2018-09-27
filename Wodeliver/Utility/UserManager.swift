//
//  UserManager.swift
//  Wodeliver
//
//  Created by Anuj Singh on 14/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserManager{
    
    static let userDetailsKey="UserDetail"
    static let userIdKey = "_id"
    static let userTypeIdKey = "accountType"
    static let userProfile = "userProfile"
    static let customerId = "customerId"
    static let deviceToken = "deviceToken"
    static let latitude = "_latitude"
    static let longitude = "_longitude"
    static let storeId = "storeId"
    static let categoryItem = "_categoryItem"
    static let category = "_category"
    static let storeMenu = "_storeMenu"
    static let cartItem = "_cartItem"
    static let deliveryBoyProfile="deliveryBoyProfile"
    static let deliveryBoyId="deliveryBoyId"
    static public func setUserDetail(detail:JSON)   {
//        if let token = detail["deviceToken"].string{
//
//        }else{
//            detail["deviceToken"] = ""
//        }
        UserDefaults.standard.set(detail.rawString()!, forKey: userDetailsKey)
        UserDefaults.standard.set(detail[userIdKey].stringValue, forKey: userIdKey)
        UserDefaults.standard.set(detail[customerId].int64Value, forKey: customerId)
        UserDefaults.standard.set(detail[userTypeIdKey].int32Value, forKey: userTypeIdKey)
         UserDefaults.standard.set(detail[storeId].stringValue, forKey: storeId)
        if detail[deliveryBoyId].string != nil{
            UserDefaults.standard.set(detail[deliveryBoyId].stringValue, forKey: deliveryBoyId)
        }
        let profile: [String:Any] = [
            "name": detail["name"].stringValue,
            "_id": detail["_id"].stringValue,
            "email": detail["email"].stringValue,
            "password": detail["password"].intValue,
            "phone": detail["phone"].intValue,
            "__v": detail["__v"].intValue,
            "updatedAt": detail["updatedAt"].stringValue,
            "customerId": detail["customerId"].intValue,
          //  "address": detail["address"].arrayValue,
            "accountType" : detail["accountType"].intValue
        ]
        UserDefaults.standard.set(profile, forKey: userProfile)
    }
    static func getUserDetail() -> JSON {
        if let json = UserDefaults.standard.string(forKey: userDetailsKey) {
            return JSON.init(parseJSON: json)
        }
        return JSON.null
    }
    static public func setDeliveryBoyProfile(detail:JSON)   {
        UserDefaults.standard.set(detail.rawString()!, forKey: deliveryBoyProfile)
    }
    static func getDeliveryBoyProfile() -> JSON {
        if let json = UserDefaults.standard.string(forKey: deliveryBoyProfile) {
            return JSON.init(parseJSON: json)
        }
        return JSON.null
    }
    static func getUserId() -> String {
        return UserDefaults.standard.object(forKey: userIdKey) as? String ?? ""
    }
    static func getStoreId() -> String {
        return UserDefaults.standard.object(forKey: storeId) as? String ?? ""
    }
    static func getUserType() -> UserType {
        return UserType(rawValue: Int32(UserDefaults.standard.integer(forKey: userTypeIdKey)))!
    }
    static func getDeliveryBoyId() -> String {
        return UserDefaults.standard.string(forKey: deliveryBoyId) ?? ""
    }
    static func getUserTypeName(type: UserType) -> String {
        switch type {
        case .customer:
            return "Customer".localized
        case .deliveryBoy:
            return "Delivery Boy".localized
        case .storeManager:
            return "Store Front".localized
        default:
            return ""
        }
    }
    
    static func getOrderStatus(type: OrderStatus) -> String {
        switch type {
        case .inProgress:
            return "InProgress".localized
        case .completed:
            return "Completed".localized
        case .delivery:
            return "Delivery".localized
        }
    }
    
    static func getBannerTypeName(type: BannerType) -> String {
        switch type {
        case .home:
            return "Home".localized
        case .storeCategory:
            return "Store Category".localized
        case .storeSearchResult:
            return "Store Search Result".localized
        }
    }
    
    static func checkIfLogin() -> Bool {
        if let _ = UserDefaults.standard.object(forKey: userDetailsKey) {
            return true
        }else{
            return false
        }
    }
    static func logout(isDisable : Bool) {
        UserDefaults.standard.removeObject(forKey: userDetailsKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: userTypeIdKey)
        UserDefaults.standard.removeObject(forKey: deliveryBoyId)
        UserDefaults.standard.removeObject(forKey: deliveryBoyProfile)
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain) 
    }
    static func setDeviceToken(token: String) {
        UserDefaults.standard.set(token, forKey: deviceToken)
    }
    static func getDeviceToken() -> String {
        if let token = UserDefaults.standard.string(forKey: deviceToken) {
            return token
        }else {
            return "no-token"
        }
    }
    static func setUserLatitude(token: Double) {
        UserDefaults.standard.set(token, forKey: latitude)
    }
    static func setUserLongitude(token: Double) {
        UserDefaults.standard.set(token, forKey: longitude)
    }
    static func getUserLatitude() -> Double {
        return UserDefaults.standard.double(forKey: latitude)
    }
    static func getUserLongitude() -> Double {
        return UserDefaults.standard.double(forKey: longitude)
    }
    static public func setItemCategory(detail:JSON)    {
        UserDefaults.standard.set(detail.rawString()!, forKey: categoryItem)
    }
    static func getItemCategory() -> JSON  {
        if let json = UserDefaults.standard.string(forKey: categoryItem) {
            return JSON.init(parseJSON: json)
        }
        return JSON.null
    }
    static public func setCategory(detail:JSON)   {
        UserDefaults.standard.set(detail.rawString()!, forKey: category)
    }
    static func getCategory() -> JSON {
        if let json = UserDefaults.standard.string(forKey: category) {
            return JSON.init(parseJSON: json)
        }
        return JSON.null
    }
    static public func setStoreItemList(detail:JSON)    {
        UserDefaults.standard.set(detail.rawString()!, forKey: storeMenu)
    }
    static func getStoreItemList() -> JSON  {
        if let json = UserDefaults.standard.string(forKey: storeMenu) {
            return JSON.init(parseJSON: json)
        }
        return JSON.null
    }
    
    static public func setCartList(detail:JSON)    {
        UserDefaults.standard.set(detail.rawString()!, forKey: cartItem)
    }
    static func getCartList() -> JSON  {
        if let json = UserDefaults.standard.string(forKey: cartItem) {
            return JSON.init(parseJSON: json)
        }
        return JSON.null
    }
    
    static public func saveCartItem(cart :JSON, id : String, quantity: String){
//        if let json = UserDefaults.standard.string(forKey: cartItem) {
//        //    return JSON.init(parseJSON: json)
//        }
        let item : [String:Any] = ["item": cart, "quantity":quantity,"id" : id]
        
        let itemArray = [item]
        
        if UserDefaults.standard.array(forKey: cartItem) != nil{
            var getItemArray = UserDefaults.standard.array(forKey: cartItem)!
            
            if getItemArray.count == 0{
                UserDefaults.standard.set(itemArray, forKey: cartItem)
            }else{
                getItemArray.append(item)
                UserDefaults.standard.set(getItemArray, forKey: cartItem)
            }
        }else{
            //UserDefaults.standard.set(itemArray, forKey: "cartItem")
             UserDefaults.standard.set(itemArray, forKey: "temp123456")
        }
        
        
        
//        var itemList = UserDefaults.standard.array(forKey: cartItem)
//        let item : [String:Any] = ["item": cart.rawString()!, "quantity":quantity,"id" : id]
//        itemList?.append(item)
//        UserDefaults.standard.set(itemList, forKey: cartItem)
//    
//        
//        if var items = UserDefaults.standard.array(forKey: cartItem){
//            let item : [String:Any] = ["item": cart.rawString()!, "quantity":quantity,"id" : id]
//            items.append(item)
//            UserDefaults.standard.set(item, forKey: cartItem)
//        }
        
    }

    static public func getCart() -> Array<Any>{
       // let item = UserDefaults.standard.value(forKey: cartItem)
       // print(item)
         if let items = UserDefaults.standard.array(forKey: cartItem){
            return items
        }
        return []
    }
    
    static func getCartCount() -> Int  {
        if let json = UserDefaults.standard.array(forKey: cartItem) {
            return json.count
        }
        return 0
    }
}
