//
//  WorkoutHistoryItem.swift
//  HealthAI
//
//  Created by Feng Guo on 11/7/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import Foundation
import RealmSwift


class WorkoutHistoryItem:Object{
    
    @objc dynamic var title: String = ""
    @objc dynamic var duration: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var hardness: String = ""
    @objc dynamic var strength: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var time: String = ""
    
    //Use for the cardio workout Item
    @objc dynamic var totalDistance: Double = 0.0
    @objc dynamic var averageSpeed: Double = 0.0
    
    
    @objc dynamic var currentDate: String = ""
    
    let subworkoutItems = List<SubworkoutHistoryItem>()
    
}
