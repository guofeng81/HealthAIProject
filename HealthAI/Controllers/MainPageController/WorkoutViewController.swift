//
//  WorkoutViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 10/30/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController {
    
    var arrayOfWorkout = [WorkoutDataModel]()
    
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var workoutView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let workout = WorkoutDataModel()
        workout.title = "Arms"
        workout.content = "Tone and develop your arm muscles.You will go through eight exercises, alternating between three sets of 10 reps and two sets of 20 reps"
        //workout.workoutDuration = "40min"
        workout.body = "upper body"
        workout.strength = "strength"
        workout.duration = "40 mins"
        workout.level = "Intemediate"
        
        
        let workout2 = WorkoutDataModel()
        workout2.title = "Back"
        workout2.content = "Tone and develop your arm muscles.You will go through eight exercises, alternating between three sets of 10 reps and two sets of 10 reps"
        //workout2.workoutDuration = "30min"
        workout2.body = "lower body"
        workout2.strength = "strength"
        workout2.duration = "30 mins"
        workout2.level = "Intemediate"
        
        
        arrayOfWorkout.append(workout)
        arrayOfWorkout.append(workout2)
        
        
        setupGesture()
        
        
        
    }
    
    func setupGesture(){
        let workoutGesture = UITapGestureRecognizer(target: self, action: #selector(workouthandleTap(sender:)))
        self.workoutView.addGestureRecognizer(workoutGesture)
        
        let historyGesture = UITapGestureRecognizer(target: self, action: #selector(historyhandleTap(sender:)))
        self.historyView.addGestureRecognizer(historyGesture)
        
    }
    
    @objc func workouthandleTap(sender:UITapGestureRecognizer){
        performSegue(withIdentifier: "goToWorkout", sender: self)
    }
    
    @objc func historyhandleTap(sender:UITapGestureRecognizer){
        performSegue(withIdentifier: "goToWorkoutHistory", sender: self)
    }
    
    
    
    
    //    @IBAction func workoutHistoryBtn(_ sender: UIButton) {
    //
    //        performSegue(withIdentifier: "goToWorkoutHistory", sender: self)
    //    }
    //
    //    @IBAction func workoutBtn(_ sender: Any) {
    //        performSegue(withIdentifier: "goToWorkout", sender: self)
    //    }
    //
    //
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWorkout" {
            let seg = segue.destination as! TodoLIstViewController
            seg.workoutList = self.arrayOfWorkout
        }
    }

}
