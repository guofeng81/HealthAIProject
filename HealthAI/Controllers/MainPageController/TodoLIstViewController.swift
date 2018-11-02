//
//  TodoLIstViewController.swift
//  workoutApp
//
//  Created by Feng Guo on 10/14/18.
//  Copyright © 2018 Feng Guo. All rights reserved.
//

import UIKit
import os.log

class TodoLIstViewController: UITableViewController{
    
    var workoutList = [WorkoutDataModel]()
    var selectedData = WorkoutDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "WorkoutTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "workoutCell")
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workoutList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedData = workoutList[indexPath.row]
        performSegue(withIdentifier: "goToWorkoutDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWorkoutDetails" {
            let seg = segue.destination as! WorkoutDetailViewController
            seg.selectedData = self.selectedData
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: WorkoutTableViewCell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as? WorkoutTableViewCell else{
            os_log("Dequeue cell isn't an instance of Workout Table View Cell")
            fatalError()
        }
        
        selectedData = workoutList[indexPath.row]
        
        cell.titleLabel.text = selectedData.title
        cell.middleLabel.text = "\(selectedData.duration) - \(selectedData.level)"
        cell.bodyLabel.text = selectedData.body
        cell.strengthLabel.text = selectedData.strength
        
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
