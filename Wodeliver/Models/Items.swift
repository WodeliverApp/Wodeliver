//
//  Item.swift
//  Wodeliver
//
//  Created by Anuj Singh on 18/01/18.
//  Copyright © 2018 Anuj Singh. All rights reserved.
//

import Foundation

class Items {
     var _id : String = ""
     var item : String = ""
     var image : String = ""
     var storeId : Store!
     var updatedAt : String = ""
     var commentsCount : Int = 0
     var sold : Int = 0
     var price : Int = 0
     var itemCategory : ItemCategory?
     var category : StoreCategory?
}
