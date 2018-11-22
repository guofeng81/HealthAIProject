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
    
    func convertMeterToMile(distance:Double)->Double {
        return distance / 1000 * 0.62
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardioCell", for: indexPath) as! CardioSummaryCell

        if let cardioWorkouts = cardiohWorkoutHistories {
             cell.titleLabel.text = cardioWorkouts[indexPath.row].title
            let distance = convertMeterToMile(distance: cardioWorkouts[indexPath.row].totalDistance)
            cell.distanceLabel.text = String(format: "%.1f",distance) + " mi"
            cell.averageSpeedLabel.text = "Average Speed: "+String(format: "%.2f",cardioWorkouts[indexPath.row].averageSpeed) + " MPH"
            cell.timeLabel.text = "Total Time: " + cardioWorkouts[indexPath.row].time
            cell.dateLabel.text = cardioWorkouts[indexPath.row].currentDate
            
        }
        
        return cell
    }
    

}
