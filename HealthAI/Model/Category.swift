//
//  Category.swift
//  HealthAI
//
//  Created by Naresh Kumar on 31/10/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name: String = ""
    @objc dynamic var content: String = ""
    let items = List<Item>()
    
}
