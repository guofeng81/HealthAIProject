//
//  WorkoutDetailViewController.swift
//  HealthAI
//
//  Created by Naresh Kumar on 31/10/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit

class WorkoutDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DataTransferDelegate {
    
    @IBOutlet var myTableView: UITableView!
    
    var selectedWorkoutItem = WorkoutItem()
    
    var selectedSubworkoutItem = SubworkoutItem()
    var workoutHistoryItem = WorkoutHistoryItem()
    
    func userDidFinishedSubworkout(subworkoutItem: SubworkoutItem) {
        selectedSubworkoutItem.done = subworkoutItem.done
        //selectedSubworkoutItem.currentDate = subworkoutItem.currentDate
        selectedSubworkoutItem.time = subworkoutItem.time
        //selectedSubworkoutItem = subworkoutItem
        print("Subworkout Item: ", subworkoutItem.done)
        
        //print("Selected Subworkout Item: ",selectedSubworkoutItem.done)
        myTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    @IBOutlet weak var contentText: UILabel!
    @IBOutlet weak var titleText: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        titleText.text = selectedWorkoutItem.title
        contentText.text = selectedWorkoutItem.content
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
        
        performSegue(withIdentifier: "goToSubworkoutStopwatch", sender: self)
        
        selectedSubworkoutItem = selectedWorkoutItem.subworkouts[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSubworkoutStopwatch"{
            let seg = segue.destination as! WorkoutClockViewController
            seg.selectedSubworkoutItem = selectedSubworkoutItem
            seg.delegate = self
        }
    }
    
    

}
