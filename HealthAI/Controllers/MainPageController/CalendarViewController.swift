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



class CalendarViewController: UIViewController {
    
   
   // @IBOutlet var calView: CalenderView!
    
    var theme = MyTheme.dark
    
    var selectedDate:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadWorkoutHistoryData()
        
        print("Selected Date:" ,selectedDate)
        
        self.title = "My Calendar"
        
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        view.addSubview(calenderView)
       // calView.addSubview(calenderView)
        
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        
        let rightBarBtn = UIBarButtonItem(title: "Light", style: .plain, target: self, action: #selector(rightBarBtnAction))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        let leftBarBtn = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(leftBarBtnAction))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
    }
    
//    func loadWorkoutHistoryData(){
//        workoutHistories = realm.objects(WorkoutHistoryItem.self)
//    }

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
