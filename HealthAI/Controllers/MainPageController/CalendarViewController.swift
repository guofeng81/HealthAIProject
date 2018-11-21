//
//  CalendarViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 11/16/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import RealmSwift

enum MyTheme {
    case light
    case dark
}

class CalendarViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
   
    let realm = try! Realm()
    
    var workoutHistories : Results<WorkoutHistoryItem>?
    
    var selectedWorkoutHistoryItem = WorkoutHistoryItem()
    
    //Divide Carido Workouts and Strength Workouts into two sections based on date
    
    
    var seletedDate : String = ""
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutHistories?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        //cell.delegate = self
        
        if let workout = workoutHistories?[indexPath.row]{
            cell.textLabel?.text = workout.title
        }else{
            cell.textLabel?.text = "No Workout Item added"
        }
        //TODO - Not sure 
        
         NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView(notification:)), name: NSNotification.Name(rawValue: "refreshDate"), object: nil)
        
        
        return cell
    }
    
    @objc func refreshTableView(notification: NSNotification){
        
        //load the selected Date data
        selectedDate = CalenderView.dateSelected
        
        print("Selected Date Here:" , selectedDate!)
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        //let date = dateFormatter.date(from: )
        
         workoutHistories = realm.objects(WorkoutHistoryItem.self).filter("currentDate == %@",selectedDate!)
        
         historyTableView.reloadData()
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedWorkoutHistoryItem = workoutHistories![indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToHistoryDetail", sender: self)
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func loadWorkoutHistoryData(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let date = dateFormatter.string(from: Date())
        
        print(date)
        
        workoutHistories = realm.objects(WorkoutHistoryItem.self).filter("currentDate == %@",date)
        historyTableView.reloadData()
    }
    
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let workoutHistroyForDeletion = self.workoutHistories?[indexPath.row]{
                do{
                    try self.realm.write{
                        self.realm.delete(workoutHistroyForDeletion)
                    }
                }catch{
                    print("Error delelting the the item using realm")
                }
            }
            
            self.historyTableView.reloadData()
        }
    }
    
    
    @IBOutlet var historyTableView: UITableView!
    
    
   // @IBOutlet var calView: CalenderView!
    
    var theme = MyTheme.dark
    
    var selectedDate:String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWorkoutHistoryData()
        
        
        self.title = "My Calendar"
        
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        
        
        view.addSubview(calenderView)
       // calView.addSubview(calenderView)
        
        
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 250).isActive=true
        
        let rightBarBtn = UIBarButtonItem(title: "Light", style: .plain, target: self, action: #selector(rightBarBtnAction))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        let leftBarBtn = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(leftBarBtnAction))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
    }
    

    @objc func leftBarBtnAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
       
    }
    
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
        if theme == .dark {
            sender.title = "Dark"
            theme = .light
            Style.themeLight()
        } else {
            sender.title = "Light"
            theme = .dark
            Style.themeDark()
        }
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
    }
    
    let calenderView: CalenderView = {
        let v=CalenderView(theme: MyTheme.dark)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass the selectedDate to the CalendarDetail TableViewController
        if segue.identifier == "goToDetail" {
            let seg = segue.destination as! CalendarDetailTableViewController
            seg.selectedDate = self.selectedDate
        }
    }
    


}
