//
//  GraphViewController.swift
//  HealthAI
//
//  Created by Naresh Kumar on 31/10/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    
    @IBOutlet weak var remainingCal: UILabel!
    @IBOutlet weak var currentCal: UILabel!
    @IBOutlet weak var goalCal: UILabel!

   
    @IBOutlet weak var piechart: PieChartView!
    
    var currentDayCal = PieChartDataEntry(value: 0)
    var remainingDayCal = PieChartDataEntry(value: 0)
    var calorieScore  = [PieChartDataEntry]()
    
    var goalValue = 0
    var currentValue = 0
    var remainingValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalCal.text = "\(goalValue)"
        
        currentCal.text = "\(currentValue)"
        remainingValue = goalValue - currentValue
        
        remainingCal.text = "\(remainingValue)"
        
        
        calorieScore = [currentDayCal, remainingDayCal]
        
        updateChart()
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func updateChart(){
        let chartDataSet = PieChartDataSet(values: calorieScore, label: nil)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.red, UIColor.blue]
        chartDataSet.colors = colors
        piechart.data = chartData
    }
    
}

