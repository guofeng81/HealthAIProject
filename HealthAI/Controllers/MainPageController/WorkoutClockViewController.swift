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
    
    @IBOutlet var subworkoutTitle: UILabel!
    
    @IBOutlet var startBtn: UIButton!
    
    @IBOutlet var resetBtn: UIButton!
    
    @IBOutlet var endBtn: UIButton!
    
    //time is only for the seconds
    var time:Int = 0
    var timer:Timer? = nil
   
    
    var delegate : DataTransferDelegate?
    
    var selectedSubworkoutItem = SubworkoutItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print("Selected Subworkout",selectedSubworkoutItem.title)
        
        
        
        setupButtons()
        subworkoutTitle.text = selectedSubworkoutItem.title
        
    }
    
    func setupButtons(){
        
        let normalGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
        startBtn.addGestureRecognizer(normalGesture)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector((longTap(_:))))
        startBtn.addGestureRecognizer(longGesture)
        
        startBtn.layer.cornerRadius = startBtn.frame.width / 2
        startBtn.clipsToBounds = true
//        resetBtn.layer.cornerRadius = resetBtn.frame.width / 2
//        resetBtn.clipsToBounds = true
//        endBtn.layer.cornerRadius = 20
//        endBtn.clipsToBounds = true
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
        
        if timer != nil {
            startBtn.setTitle("Start", for: .normal)
            timer!.invalidate()
            timer = nil
        }else{
            startBtn.setTitle("Pause", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(WorkoutClockViewController.action),userInfo: nil, repeats: true)
            
        }
    }
    
    
    @objc func action(){
        time += 1
        let minutesPortion = String(format: "%02d", self.time / 60)
        let secondsPortion = String(format: "%02d", self.time % 60)
        timeLabel.text = "\(minutesPortion):\(secondsPortion)"
    }
    
    @objc func longTap(_ sender:UIGestureRecognizer){
        if time != 0 {
            time = 0
            let minutesPortion = String(format: "%02d", self.time / 60)
            let secondsPortion = String(format: "%02d", self.time % 60)
            timeLabel.text = "\(minutesPortion):\(secondsPortion)"
        }
    }
    
    @objc func normalTap(_ sender:UIGestureRecognizer) {
        if timer != nil {
            startBtn.setTitle("Start", for: .normal)
            timer!.invalidate()
            timer = nil
        }else{
            startBtn.setTitle("Pause", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(WorkoutClockViewController.action),userInfo: nil, repeats: true)
            
        }
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        if time != 0 {
            time = 0
            timeLabel.text = String(format: "02d%02d", time)
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
