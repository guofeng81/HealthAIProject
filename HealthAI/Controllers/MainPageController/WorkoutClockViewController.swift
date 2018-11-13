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
    
    @IBOutlet var startBtn: UIButton!
    
    @IBOutlet var resetBtn: UIButton!
    
    @IBOutlet var endBtn: UIButton!
    
    var time:Double = 0.00
    var timer:Timer? = nil
    
    var delegate : DataTransferDelegate?
    
    var selectedSubworkoutItem = SubworkoutItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        
        
    }
    
    func setupButtons(){
        startBtn.layer.cornerRadius = startBtn.frame.width / 2
        startBtn.clipsToBounds = true
        resetBtn.layer.cornerRadius = resetBtn.frame.width / 2
        resetBtn.clipsToBounds = true
        endBtn.layer.cornerRadius = 20
        endBtn.clipsToBounds = true
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func endWorkoutBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "End Workout", message: "Are you sure you want to end your workout?", preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "End & Save Workout", style: .default, handler: { (action) in
            self.saveWorkout()
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "End Without Saving", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Back to Workout", style: .cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }

    //MARK - Perform Data Save!
    
    func saveWorkout(){
        
        // get the date time String from the date object
        
        selectedSubworkoutItem.time = time
        selectedSubworkoutItem.done = true
        
        //pass the selectedSubworkoutItem data back to the previous view controller
        
        delegate!.userDidFinishedSubworkout(subworkoutItem: selectedSubworkoutItem)

    }

    @IBAction func startBtn(_ sender: UIButton) {
        
        if !sender.isSelected {
            //implement the pause
            sender.setTitle("Start", for: .normal)
            //let timer pause
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }else{
                //implement the start 
                if timer == nil {
                    timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(WorkoutClockViewController.action),userInfo: nil, repeats: true)
                }else {
                    print("Timer has been created.")
                }
                
                sender.setTitle("Pause", for: .normal)
                
            }
        }
        sender.isSelected = !sender.isSelected
    }
    
    @objc func action(){
        time += 0.01
        timeLabel.text = String(format: "%.2f",time)
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        if time != 0 {
            time = 0
            timeLabel.text = String(time)
        }
    }
    
    //Play the workout tutorial video
    
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
