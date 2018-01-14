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
    static let userIdKey = "id"
    static let userTypeIdKey = "userTypeId"
    
    static public func setUserDetail(detail:JSON)   {
        UserDefaults.standard.set(detail.rawString()!, forKey: userDetailsKey)
        UserDefaults.standard.set(detail[userIdKey].int64Value, forKey: userIdKey)
        UserDefaults.standard.set(detail[userTypeIdKey].int32Value, forKey: userTypeIdKey)
        var profile: [String:Any] = [
            "Name": detail["name"].stringValue,                // String
            "Identity": detail["id"].int64Value,               // String or number
            "Email": detail["email"].stringValue,              // Email address of the user
            "MSG-email": true,                     // Disable email notifications
            "MSG-push": true,                       // Enable push notifications
            "MSG-sms": true,                        // Disable SMS notifications
            "UsertypeId": detail["userTypeId"].intValue
        ]
        if let profileImage = detail["profileImage"]["mediaPath"].string {
            profile["Photo"] = profileImage
        }
        if let dob = detail["dob"].double {
            profile["dob"] = Date.init(timeIntervalSince1970: dob/1000)
        }
        if let university = detail["university"]["name"].string {
            profile["Univertsity"] = university
        }
        if let gender = detail["gender"].string {
            if gender == "Male" {
                profile["Gender"] = "M"
            }else {
                profile["Gender"] = "F"
            }
        }
        if let department = detail["department"]["name"].string {
            profile["Department"] = department
        }
       }
}
