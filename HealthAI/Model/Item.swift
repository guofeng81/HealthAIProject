//
//  Item.swift
//  HealthAI
//
//  Created by Naresh Kumar on 31/10/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object{
    @objc dynamic var title : String = ""
    @objc dynamic var content : String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
