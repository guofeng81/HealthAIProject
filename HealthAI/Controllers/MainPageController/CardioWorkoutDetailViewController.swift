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
        
        setupButtons()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endWorkoutPressed(sender:)))
        
    }
    
    
    @objc func endWorkoutPressed(sender:AnyObject){
        print("End")
        
        let alert = UIAlertController(title: "End Workout", message: "Are you sure you want to end your workout?", preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "End Workout", style: .default, handler: { (action) in
            self.saveWorkout()
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Back to Workout", style: .cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet var startBtn: UIButton!
    
    
    func setupButtons(){
        
        startBtn.layer.cornerRadius = startBtn.frame.width / 2
        startBtn.clipsToBounds = true
        
        let normalGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
        startBtn.addGestureRecognizer(normalGesture)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector((longTap(_:))))
        startBtn.addGestureRecognizer(longGesture)
        
        startBtn.layer.cornerRadius = startBtn.frame.width / 2
        startBtn.clipsToBounds = true
        
        
        setupButtonImage(imageName: "play")
        
    }
    
    @objc func longTap(_ sender:UIGestureRecognizer){
        if time != 0 {
            time = 0
            let minutesPortion = String(format: "%02d", self.time / 60)
            let secondsPortion = String(format: "%02d", self.time % 60)
            let hoursPortion = String(format: "%02d", self.time % 3600)
            timeLabel.text = "\(hoursPortion):\(minutesPortion):\(secondsPortion)"
        }
    }
    
    @objc func normalTap(_ sender:UIGestureRecognizer) {
        if timer != nil {
            setupButtonImage(imageName: "play")
            timer!.invalidate()
            timer = nil
        }else{
            setupButtonImage(imageName: "pause")
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(WorkoutClockViewController.action),userInfo: nil, repeats: true)
            
        }
    }
    
    func setupButtonImage(imageName:String){
        
        let startBtnimage = UIImageView()
        startBtnimage.frame = startBtn.frame
        startBtnimage.contentMode = .scaleAspectFit
        startBtnimage.clipsToBounds = true
        startBtnimage.image = UIImage(named: imageName)
        startBtn.addSubview(startBtnimage)
        
    }

    
    var time:Int = 0
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
        
//        sender.isSelected = !sender.isSelected
//
//        if !sender.isSelected {
//            //implement the pause
//            manager.stopUpdatingLocation()
//            startLocation = nil
//            lastLocation = nil
//            sender.setTitle("Start", for: .normal)
//            //let timer pause
//            if timer != nil {
//                timer!.invalidate()
//                timer = nil
//            }
//
//
//        }else{
//            //implement the start workout
//            setupStartTimer()
//            manager.startUpdatingLocation()
//            speedLabel.text = String(0)
//            sender.setTitle("Pause", for: .normal)
//
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var speed: CLLocationSpeed = CLLocationSpeed()
        speed = (manager.location?.speed)!
        print("Speed:\(speed) mph ")
        
        speedLabel.text = String(format: "%.2f", speed) + " MPH"
        
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
            totalDistance.text = String(format: "%.2f", traveledDistance) + " M"
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
    
    
    @objc func action(){
        time += 1
        let minutesPortion = String(format: "%02d", self.time / 60)
        let secondsPortion = String(format: "%02d", self.time % 60)
        let hoursPortion = String(format: "%02d", self.time % 3600)
        timeLabel.text = "\(hoursPortion):\(minutesPortion):\(secondsPortion)"
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
        selectedWorkoutHistoryItem.averageSpeed = traveledDistance / Double(time)
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
