//
//  CalendarStrengthDetailTableViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 11/24/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import RealmSwift

class CalendarStrengthDetailTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    let realm = try! Realm()
    
    var strengthSelectedDate = ""
    
    var strengthWorkoutHistories : Results<WorkoutHistoryItem>?
    
    func loadStrengthWorkoutHistoryData(){
        
        let strengthPredicate = NSPredicate(format: "currentDate==%@ AND type==%@", strengthSelectedDate,"Strength")
        strengthWorkoutHistories = realm.objects(WorkoutHistoryItem.self).filter(strengthPredicate)
        
        
    }
    
     var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStrengthWorkoutHistoryData()
        
        print("Strength Selected Date: ", strengthSelectedDate)
        
        for i in 0...strengthWorkoutHistories!.count-1 {
            
            var subworkouts = [String]()
            
            for j in 0...strengthWorkoutHistories![i].subworkoutItems.count-1 {
                
                subworkouts.append(strengthWorkoutHistories![i].subworkoutItems[j].title)
                print(strengthWorkoutHistories![j].title)
                print("Subworkout Title:",strengthWorkoutHistories![i].subworkoutItems[j].title )
                
            }
            
            let section = Section(genre: strengthWorkoutHistories![i].title, movies: subworkouts, expanded: false)
            
            sections.append(section)
           
        }
    
    }
    
//    var sections = [
//        Section(genre: "🦁 Animation",
//                movies: ["The Lion King", "The Incredibles"],
//                expanded: false),
//        Section(genre: "💥 Superhero",
//                movies: ["Guardians of the Galaxy", "The Flash", "The Avengers", "The Dark Knight"],
//                expanded: false),
//        Section(genre: "👻 Horror",
//                movies: ["The Walking Dead", "Insidious", "Conjuring"],
//                expanded: false)
//    ]
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return strengthWorkoutHistories?.count ?? 1
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded) {
            return 44
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].genre, section: section, delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
        cell.textLabel?.text = sections[indexPath.section].movies[indexPath.row]
        return cell
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        
        tableView.beginUpdates()
        for i in 0 ..< sections[section].movies.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let strengthWorkoutVC = StrengthWorkoutVC()
//        strengthWorkoutVC.customInit(workoutName: sections[indexPath.section].movies[indexPath.row])
//        tableView.deselectRow(at: indexPath, animated: true)
//        //self.navigationController?.pushViewController(strengthWorkoutVC, animated: true)
//    }
    
    
    

    
    

}
