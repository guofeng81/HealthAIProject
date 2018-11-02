//
//  WorkoutDetailViewController.swift
//  HealthAI
//
//  Created by Naresh Kumar on 31/10/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit

class WorkoutDetailViewController: UIViewController {
    var selectedData = WorkoutDataModel()
    

    @IBOutlet weak var contentText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    //    @IBOutlet weak var titleText: UILabel!
    
//    @IBOutlet weak var contentText: UILabel!
    //    @IBOutlet weak var titleText: UILabel!
//    @IBOutlet weak var contentText: UILabel!
//
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.text = selectedData.title
        contentText.text = selectedData.content
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func startWorkoutBtn(_ sender: Any) {
        performSegue(withIdentifier: "beginWorkout", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "beginWorkout" {
            let seg = segue.destination as! WorkoutClockViewController
            
            seg.selectedData = self.selectedData
        }
    }
    

}
