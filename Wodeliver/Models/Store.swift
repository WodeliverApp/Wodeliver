//
//  Store.swift
//  Wodeliver
//
//  Created by Anuj Singh on 18/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import Foundation

class Store{
     var _id : String = ""
     var address : String = ""
     var name : String = ""
     var city : String = ""
     var image : String = ""
     var updatedAt : String = ""
     var latLong : LatLong?
     var sequence : Int = 0
     var commentCounts : Int = 0
     var dislikes : Int = 0
     var likes : Int = 0
}
