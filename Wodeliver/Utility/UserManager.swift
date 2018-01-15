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
    
    static public func setUserDetail(detail:JSON)   {
        UserDefaults.standard.set(detail.rawString()!, forKey: userDetailsKey)
        UserDefaults.standard.set(detail[userIdKey].stringValue, forKey: userIdKey)
        UserDefaults.standard.set(detail[customerId].int64Value, forKey: customerId)
        UserDefaults.standard.set(detail[userTypeIdKey].int32Value, forKey: userTypeIdKey)
        let profile: [String:Any] = [
            "name": detail["name"].stringValue,
            "_id": detail["_id"].stringValue,
            "email": detail["email"].stringValue,
            "password": detail["password"].intValue,
            "phone": detail["phone"].intValue,
            "__v": detail["__v"].intValue,
            "updatedAt": detail["updatedAt"].stringValue,
            "customerId": detail["customerId"].intValue,
            "address": detail["address"].arrayValue,
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
    static func getUserId() -> String {
        return UserDefaults.standard.object(forKey: userIdKey) as? String ?? ""
    }
    
    static func getUserType() -> UserType {
        return UserType(rawValue: Int32(UserDefaults.standard.integer(forKey: userTypeIdKey)))!
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
}
