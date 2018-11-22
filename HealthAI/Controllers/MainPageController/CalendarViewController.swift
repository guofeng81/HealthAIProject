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
    
    var strengthWorkoutHistories : Results<WorkoutHistoryItem>?
    var cardioWorkoutHistories : Results<WorkoutHistoryItem>?
    
    var selectedWorkoutHistoryItem = WorkoutHistoryItem()
    var arrayOfStrengthWorkouts = [WorkoutHistoryItem]()
    
    var arrayOfCardioWorkouts = [WorkoutHistoryItem]()
    
    var numberOfCardioWorkouts = 0
    var numberOfStrengthWorkouts = 0
    
    
    //Divide Carido Workouts and Strength Workouts into two sections based on date
    
    var seletedDate : String = ""
    
     var arrayOfCardioAndStrength = [String]()
   
    
    func convertMeterToMile(distance:Double)->Double {
         return distance / 1000 * 0.62
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return workoutHistories?.count ?? 1
        
        return arrayOfCardioAndStrength.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! CalendarHistoryCell
        
        // make sure the cell is fetching the cardio workout
        
        if arrayOfCardioAndStrength.count > 0 {
            cell.historyCellTitle.text = arrayOfCardioAndStrength[indexPath.row]
            if arrayOfCardioAndStrength.contains("Cardio"){
                let distance = calculateCardioWorkoutTotalDistance(cardioWorkoutArray: arrayOfCardioWorkouts)
                cell.distanceLabel.text = String(format:"%.1f",convertMeterToMile(distance: distance)) + " mi"
                
            }else{
                cell.distanceLabel.text = ""
            }
        }
        
        //make sure the cell is fetching the strength workout
        
        //TODO -
        
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
        
        let strengthPredicate = NSPredicate(format: "currentDate==%@ AND type==%@", selectedDate!,"Strength")
        let cardioPredicate = NSPredicate(format: "currentDate==%@ AND type==%@", selectedDate!,"Cardio")

        strengthWorkoutHistories = realm.objects(WorkoutHistoryItem.self).filter(strengthPredicate)
        cardioWorkoutHistories = realm.objects(WorkoutHistoryItem.self).filter(cardioPredicate)

        arrayOfCardioAndStrength = [String]()
        
        arrayOfStrengthWorkouts = [WorkoutHistoryItem]()
        arrayOfCardioWorkouts = [WorkoutHistoryItem]()

        if let strengthWorkouts = strengthWorkoutHistories {
            if strengthWorkouts.count > 0{
                arrayOfCardioAndStrength.append("Strength")
                for strengthWorkout in strengthWorkouts {
                    arrayOfStrengthWorkouts.append(strengthWorkout)
                }
            }
        }

        if let cardioWorkouts = cardioWorkoutHistories {
            if cardioWorkouts.count > 0 {
                arrayOfCardioAndStrength.append("Cardio")
                for cardioWorkout in cardioWorkouts {
                    arrayOfCardioWorkouts.append(cardioWorkout)
                }
            }
        }

        print("Reload array",arrayOfCardioAndStrength)
        
        historyTableView.reloadData()
    }

    func calculateCardioWorkoutTotalDistance(cardioWorkoutArray:[WorkoutHistoryItem])->Double{
        
        var distance:Double = 0
        
        for cardioWorkout in cardioWorkoutArray {
            distance += cardioWorkout.totalDistance
        }
        
        return distance
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arrayOfCardioAndStrength[indexPath.row] == "Strength" {
            performSegue(withIdentifier: "goToStrengthDetail", sender: self)
        }else if arrayOfCardioAndStrength[indexPath.row] == "Cardio" {
            performSegue(withIdentifier: "goToCardioDetail", sender: self)
        }
        
        //selectedWorkoutHistoryItem = workoutHistories![indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //performSegue(withIdentifier: "goToHistoryDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         NotificationCenter.default.addObserver(self, selector: #selector(refresh(notification:)), name: NSNotification.Name(rawValue: "refreshSDate"), object: nil)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        
        let date = dateFormatter.string(from: Date())
        
        
        //pass the selectedDate to the CalendarDetail TableViewController
        if segue.identifier == "goToStrengthDetail" {
            let seg = segue.destination as! CalendarDetailStrengthTableViewController
            
            if selectedDate == nil {
                seg.strengthSelectedDate = date
            }else{
                 seg.strengthSelectedDate = self.selectedDate!
            }
            print("Selected Date!!!!",self.selectedDate!)
            
        }else if segue.identifier == "goToCardioDetail" {
            
            let seg = segue.destination as! CalendarDetailCardioTableViewController
            if selectedDate == nil {
                seg.cardioSelectedDate = date
            }else{
                seg.cardioSelectedDate = self.selectedDate!
            }
            //seg.cardioSelectedDate = self.selectedDate!
            
        }
    }
    
    @objc func refresh(notification: NSNotification){
        selectedDate = CalenderView.dateSelected
    }

    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //first time load the realm
    
    func loadWorkoutHistoryData(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let date = dateFormatter.string(from: Date())
        
        arrayOfCardioAndStrength = [String]()
        
        print(date)
        
        let strengthPredicate = NSPredicate(format: "currentDate==%@ AND type==%@", date,"Strength")
        let cardioPredicate = NSPredicate(format: "currentDate==%@ AND type==%@", date,"Cardio")
        
        workoutHistories = realm.objects(WorkoutHistoryItem.self).filter("currentDate == %@" ,date)
        
        strengthWorkoutHistories = realm.objects(WorkoutHistoryItem.self).filter(strengthPredicate)
        cardioWorkoutHistories = realm.objects(WorkoutHistoryItem.self).filter(cardioPredicate)


        if let strengthWorkouts = strengthWorkoutHistories {
            if strengthWorkouts.count > 0{
               arrayOfCardioAndStrength.append("Strength")
            }
        }

        if let cardioWorkouts = cardioWorkoutHistories {
            if cardioWorkouts.count > 0 {
                arrayOfCardioAndStrength.append("Cardio")
            }
        }

        print(arrayOfCardioAndStrength)
        
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
    
 
    


}
