//
//  CardioWorkoutTableViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 11/12/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit

class CardioWorkoutTableViewController: UITableViewController {

    let workoutImages = ["runningImage","cyclingImage","walkingImage"]
    let workoutTitles = ["Running","Cycling", "Walking"]
    
    
    var arrayOfCardioWorkout = [CardioWorkoutItem]()
    
    var selectedCardioWorkoutItem = CardioWorkoutItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cardioWorkout = CardioWorkoutItem()
        cardioWorkout.title = "Cycling"
        
        arrayOfCardioWorkout.append(cardioWorkout)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutTitles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cardioCell", for: indexPath)
        
        self.selectedCardioWorkoutItem = arrayOfCardioWorkout[indexPath.row]
        
        cell.textLabel!.text = selectedCardioWorkoutItem.title
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCardioWorkout", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCardioWorkout" {
            let seg = segue.destination as! CardioWorkoutDetailViewController
            seg.selectedCardioWorkoutItem = self.selectedCardioWorkoutItem
        }
    }
    

    
}
