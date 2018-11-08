//
//  WorkoutViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 10/30/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController {
    
    var workoutItems = [WorkoutItem]()
    
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var workoutView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let workout = WorkoutItem()
        workout.title = "Arms"
        workout.content = "Tone and develop your arm muscles.You will go through eight exercises, alternating between three sets of 10 reps and two sets of 20 reps"
        //workout.workoutDuration = "40min"
        workout.body = "upper body"
        workout.strength = "strength"
        workout.duration = "40 mins"
        workout.hardness = "Intemediate"
        
        
        let subworkout1 = SubworkoutItem()
        subworkout1.title = "Barbell Biceps Curl"
        
        let subworkout2 = SubworkoutItem()
        subworkout2.title = "Barbell Reverse Curl"
        
        workout.subworkouts.append(subworkout1)
        workout.subworkouts.append(subworkout2)
        
        let workout2 = WorkoutItem()
        workout2.title = "Back"
        workout2.content = "Tone and develop your back muscles.You will go through five exercises, alternating between three sets of 10 reps and two sets of 10 reps"
        workout2.body = "lower body"
        workout2.strength = "strength"
        workout2.duration = "30 mins"
        workout2.hardness = "Intemediate"
        
        let subworkout3 = SubworkoutItem()
        subworkout3.title = "Barbell Biceps Curl"
        
        let subworkout4 = SubworkoutItem()
        subworkout4.title = "Barbell Reverse Curl"
        
        workout2.subworkouts.append(subworkout3)
        workout2.subworkouts.append(subworkout4)
        
        
        workoutItems.append(workout)
        workoutItems.append(workout2)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWorkout" {
            let seg = segue.destination as! TodoLIstViewController
            seg.workoutItems = self.workoutItems
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToWorkout" {
//            let seg = segue.destination as! TodoListViewController
//            seg.workoutItems = self.workoutItems
//        }
//    }

}
