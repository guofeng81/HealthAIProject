//
//  DiabetesScoreViewController.swift
//  HealthAI
//
//  Created by Naresh Kumar on 31/10/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit


class DiabetesScoreViewController: UIViewController {
    
    @IBOutlet weak var scoreView: UIView!
    
    @IBOutlet weak var scorePercent: UILabel!
    
    //
//    @IBOutlet weak var scoreView: UIView!
//
//    @IBOutlet weak var scorePercent: UILabel!
    
    var scoreValue:Int = 0
    
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(scoreView)
        scorePercent.text = "\(scoreValue) %"
        
        let trackLayer = CAShapeLayer()
        let center = scoreView.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 50, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let scoreCircularPath = UIBezierPath(arcCenter: center, radius: 50, startAngle: -CGFloat.pi / 2, endAngle: (((2 * CGFloat.pi)/100) * CGFloat(scoreValue)) - (CGFloat.pi / 2) , clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.black.cgColor
        trackLayer.lineWidth = 20
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        scoreView.layer.addSublayer(trackLayer)
        
        
        shapeLayer.path = scoreCircularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        scoreView.layer.addSublayer(shapeLayer)
        scoreAnimation()
    }
    
    func scoreAnimation(){
        print("Animating chart")
        
        let basicAnimation = CABasicAnimation(keyPath:"strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 3
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "Basic")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func generatePDF(_ sender: Any) {
    }
    
    
    
    
}
