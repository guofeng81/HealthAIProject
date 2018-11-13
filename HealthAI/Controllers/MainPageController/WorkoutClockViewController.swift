//
//  WorkoutClockViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 07/11/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import RealmSwift
import AVKit

protocol DataTransferDelegate:class {
    func userDidFinishedSubworkout(subworkoutItem:SubworkoutItem)
}

class WorkoutClockViewController: UIViewController {
    
    var time:Double = 0.00
    var timer:Timer? = nil
    
    var delegate : DataTransferDelegate?
    
    var selectedSubworkoutItem = SubworkoutItem()
    
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
        
        // only save the time duration and current data time
        
        //let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        
        selectedSubworkoutItem.time = time
        //selectedSubworkoutItem.currentDate = currentDateTime
        selectedSubworkoutItem.done = true
        
        delegate!.userDidFinishedSubworkout(subworkoutItem: selectedSubworkoutItem)
        
        
        print(selectedSubworkoutItem.done)
        print(selectedSubworkoutItem.time)
        // print(selectedSubworkoutItem.currentDate!)
        
        //workout.time = formatter.string(from: currentDateTime)
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
    
    
    
    @IBAction func videoPlayBtn(_ sender: UIButton) {
        
        if let path = Bundle.main.path(forResource: "video", ofType: "MOV"){
            
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            
            present(videoPlayer,animated: true,completion: {
                video.play()
                
            })
            
        }
    }
    
    
    
    
    
    

}
