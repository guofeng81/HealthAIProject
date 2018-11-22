//
//  CalendarDetailCardioTableViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 11/22/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import RealmSwift

class CalendarDetailCardioTableViewController: UITableViewController {

     let realm = try! Realm()
    
    var cardioSelectedDate = ""
    
    //var arrayOfCardioWorkouts = [WorkoutHistoryItem]()
    
     var cardiohWorkoutHistories : Results<WorkoutHistoryItem>?
    
    func loadCardioWorkoutHistoryData(){
        
        let cardioPredicate = NSPredicate(format: "currentDate==%@ AND type==%@", cardioSelectedDate,"Cardio")
        cardiohWorkoutHistories = realm.objects(WorkoutHistoryItem.self).filter(cardioPredicate)
        
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCardioWorkoutHistoryData()
        
        print("Cardio Selected Date: ",cardioSelectedDate)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardiohWorkoutHistories?.count ?? 1
    }
    
   

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardioCell", for: indexPath)

        if let cardioWorkouts = cardiohWorkoutHistories {
             cell.textLabel?.text = cardioWorkouts[indexPath.row].title
        }
        
        return cell
    }
    

}
