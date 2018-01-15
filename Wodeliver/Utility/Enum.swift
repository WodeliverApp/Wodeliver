//
//  Enum.swift
//  Wodeliver
//
//  Created by Anuj Singh on 15/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import Foundation

enum UserType: Int32 {
    case none = -1
    case storeManager = 1
    case customer = 2
    case deliveryBoy = 3
}

enum UserDetail : String {
    case name = "name"
    case _id = "_id"
    case email = "email"
    case password = "password"
    case phone = "phone"
    case __v = "__v"
    case updatedAt = "updatedAt"
    case createdAt = "createdAt"
    case customerId = "customerId"
    case address = "address"
}

enum DeviceType: Int32 {
    case none = -1
    case iOS = 1
    case android = 2
}
