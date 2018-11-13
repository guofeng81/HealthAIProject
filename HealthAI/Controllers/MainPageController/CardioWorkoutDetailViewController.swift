//
//  CardioWorkoutDetailViewController.swift
//  HealthAI
//
//  Created by Feng Guo on 11/12/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit
import CoreLocation

class CardioWorkoutDetailViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var map: MKMapView!
    
    var selectedCardioWorkoutItem = CardioWorkoutItem()
    
    var selectedWorkoutHistoryItem = WorkoutHistoryItem()
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedWorkoutHistoryItem.title = selectedCardioWorkoutItem.title
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.activityType = .fitness
        
        map.mapType = MKMapType(rawValue: 0)!
        map.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        map.delegate = self
        
        manager.startMonitoringSignificantLocationChanges()
        manager.distanceFilter = 5
    }
    

    
    var time:Double = 0.00
    var timer:Timer? = nil

    
    var traveledDistance:Double = 0
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var startDate: Date!
    
    var averageSpeed: Double = 0
    var totalTime: Double = 0
    
    
    @IBOutlet var speedLabel: UILabel!
    
    @IBOutlet var totalDistance: UILabel!
    
     var isCheck = false
    
    
    @IBAction func startWorkoutBtn(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if !sender.isSelected {
            //implement the pause
            manager.stopUpdatingLocation()
            startLocation = nil
            lastLocation = nil
            sender.setTitle("Start", for: .normal)
            //let timer pause
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
            
            
        }else{
            //implement the start workout
            setupStartTimer()
            manager.startUpdatingLocation()
            speedLabel.text = String(0)
            sender.setTitle("Pause", for: .normal)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var speed: CLLocationSpeed = CLLocationSpeed()
        speed = (manager.location?.speed)!
        print("Speed:\(speed) mph ")
        
        speedLabel.text = String(speed)
        
        if startDate == nil {
            startDate = Date()
        } else {
            
            totalTime = Date().timeIntervalSince(startDate)
            print("elapsedTime:", String(format: "%.0fs", Date().timeIntervalSince(startDate)))
        }
        
        
        print(startDate)
        
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            
            traveledDistance += lastLocation.distance(from: location)
            let straightDistance = startLocation.distance(from: location)
            
            print("Traveled Distance:",  traveledDistance)
            print("Straight Distance:", straightDistance)
            totalDistance.text = String(traveledDistance)
            let polyline = MKPolyline(coordinates: [lastLocation.coordinate,location.coordinate], count: 2)
            self.map.addOverlay((polyline),level: .aboveRoads)
        }
        lastLocation = locations.last
        
        
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        
        self.map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
        
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        renderer.lineWidth = 5.0
        
        return renderer
        
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    
    func setupStartTimer(){
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CardioWorkoutDetailViewController.action),userInfo: nil, repeats: true)
        }else {
            print("Timer has been created.")
        }
    }
    
    @objc func action(){
        time += 1
        timeLabel.text = String(format: "%.2f",time)
    }
    
    
    @IBAction func endWorkoutBtn(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "End Workout", message: "Are you sure you want to end your workout?", preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "End & Save Workout", style: .default, handler: { (action) in
            self.saveWorkout()
            //need to pop up to the choose workout screen
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "End Without Saving", style: .default, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Back to Workout", style: .cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func saveWorkout(){
        
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        //        let formatter = DateFormatter()
        //        formatter.timeStyle = .medium
        //        formatter.dateStyle = .long
        //
        
        selectedWorkoutHistoryItem.title = selectedCardioWorkoutItem.title
        print("Cardio workout title: ",selectedCardioWorkoutItem.title)
        selectedWorkoutHistoryItem.averageSpeed = traveledDistance/time
        selectedWorkoutHistoryItem.currentDate = currentDateTime
        selectedWorkoutHistoryItem.totalDistance = traveledDistance
        
        
        // get the date time String from the date object
        
        
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(selectedWorkoutHistoryItem)
            }
        }catch{
            print("Error using Realm!!")
        }
        
        print("workout Data save")
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
