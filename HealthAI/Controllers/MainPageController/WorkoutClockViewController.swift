//
//  WorkoutClockViewController.swift
//  HealthAI
//
//  Created by Naresh Kumar on 31/10/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import RealmSwift

class WorkoutClockViewController: UIViewController {
    
    var time:Double = 0.00
    var timer:Timer? = nil
    
    var selectedData = WorkoutDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var workout = Workout()
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func endWorkoutBtn(_ sender: Any) {
        
                        //UIAlert has three options
                        //1. End with saving the workout data
                        //2. End without saving the workout data
                        //3. Cancel
        
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

    //MARK - Perform Data Save!
    
    func saveWorkout(){
        
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        
        workout.title = self.selectedData.title
        workout.time = formatter.string(from: currentDateTime)
        
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(workout)
            }
        }catch{
            print("Error using Realm!!")
        }
        
        print("workout Data save")
    }
    
    @IBAction func startBtn(_ sender: Any) {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(WorkoutClockViewController.action),userInfo: nil, repeats: true)
        }else {
            print("Timer has been created.")
        }
    }
    
    @objc func action(){
        time += 0.01
        timeLabel.text = String(format: "%.2f",time)
    }
    
    @IBAction func pauseBtn(_ sender: Any) {
                                if timer != nil {
                                    timer!.invalidate()
                                    timer = nil
                                }
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        if time != 0 {
            time = 0
            timeLabel.text = String(time)
        }
    }

}
