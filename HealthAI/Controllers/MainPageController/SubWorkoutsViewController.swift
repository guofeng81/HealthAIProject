//
//  SubWorkoutsViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 11/7/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import RealmSwift

class SubWorkoutsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var selectedWorkoutItem = WorkoutItem()
    
    var workoutHistoryItem = WorkoutHistoryItem()
    
    
    @IBOutlet var endWorkoutBtn: UIButton!
  
    
    @IBAction func endWorkoutBtn(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "End Workout", message: "Are you sure you want to end your workout?", preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "End & Save Workout", style: .default, handler: { (action) in
            self.saveWorkout()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "End Without Saving", style: .default, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Back to Workout", style: .cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func saveWorkout(){
        
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        
        
        workoutHistoryItem.title = self.selectedWorkoutItem.title
        
        for index in 0..<self.selectedWorkoutItem.subworkouts.count {
            
            if selectedWorkoutItem.subworkouts[index].done == true {
                let subworkoutHistoryItem = SubworkoutHistoryItem()
                subworkoutHistoryItem.title = self.selectedWorkoutItem.subworkouts[index].title
                workoutHistoryItem.subworkoutItems.append(subworkoutHistoryItem)
            }
        }
        
        
        
        //workout.time = formatter.string(from: currentDateTime)
        
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(workoutHistoryItem)
            }
        }catch{
            print("Error using Realm!!")
        }
        
        print("workout Data save")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedWorkoutItem.subworkouts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subworkoutCell", for: indexPath)
        
        cell.textLabel!.text = selectedWorkoutItem.subworkouts[indexPath.row].title
        
        if selectedWorkoutItem.subworkouts[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedWorkoutItem.subworkouts[indexPath.row].done = !selectedWorkoutItem.subworkouts[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
}

