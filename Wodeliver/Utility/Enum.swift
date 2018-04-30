//
//  Enum.swift
//  Wodeliver
//
//  Created by Anuj Singh on 15/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import Foundation
import UIKit

enum UserType: Int32 {
    case none = -1
    case customer = 1
    case storeManager = 2
    case deliveryBoy = 3
}

enum OrderStatus: Int32 {
    case inProgress = 1
    case completed = 2
    case delivery = 3
}

enum BannerType: Int32 {
    case home = 0
    case storeCategory = 1
    case storeSearchResult = 2
}

protocol Printable {
    var description: String { get }
}

enum UserTypeString: Int, Printable {
    case customer = 1
    case storeManager = 2
    case deliveryBoy = 3
    static var count: Int { return UserTypeString.deliveryBoy.hashValue + 1  }
    
    var description: String {
        switch self {
        case .customer: return "Customer"
        case .storeManager   : return "Delivery Boy"
        case .deliveryBoy  : return "Store Front"
       
        }
    }
}

enum BannerTypeString: Int, Printable {
    case home = 0
    case storeCategory = 1
    case storeSearchResult = 2
    static var count: Int { return UserTypeString.deliveryBoy.hashValue + 1  }
    
    var description: String {
        switch self {
        case .home: return "Home"
        case .storeCategory   : return "Store Category"
        case .storeSearchResult  : return "Store Search Result"
            
        }
    }
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
