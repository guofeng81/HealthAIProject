//
//  DiabetesFormViewController.swift
//  Alamofire
//
//  Created by Naresh Kumar on 31/10/18.
//

import UIKit

class DiabetesFormViewController: UIViewController {
    
    @IBOutlet weak var glucoseValue: UITextField!
    
    @IBOutlet weak var heightValue: UITextField!
    
    @IBOutlet weak var weightValue: UITextField!
    
    @IBOutlet weak var bloodPressureValue: UITextField!
    
    @IBOutlet weak var diabetesPedigreeValue: UITextField!
        
    var score:Int = 0
    var scoreValue:Int = 0
    let url  = URL(string: "https://f58cbluk1h.execute-api.us-east-1.amazonaws.com/ver1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    typealias CompletionHandler = (_ value: Int) -> Void
    
    
    func postAndGetData(url: URL, completion:@escaping CompletionHandler){
        let yourBMIValue = Float(weightValue.text!)!/(powf(Float(heightValue.text!)!/100, 2))
        let json: [String: Any] = ["Glucose":Float(glucoseValue.text!)!, "BloodPressure":Float(bloodPressureValue.text!)!, "BMI":yourBMIValue, "DiabetesPedigreeFunction" : 0.5]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do{
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Int] {
                        print("printSomething")
                        print(responseJSON)
                        self.score = responseJSON["Score"]!
                        
                        
                        
                        print("Inside Score:\(self.score)")
                    }
                }
            }
            else {
                print(error!.localizedDescription)
            }
        }
        print("Hey")
        print("Outside Score\(self.score)")
        completion(self.score)
        task.resume()
        
        
        
        
        
        
        
        // return self.score
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func trackButton(_ sender: Any) {
                if let url = url {
                    //scoreValue =
                    postAndGetData(url: url) { (value) in
                        self.score = value
        
                        print("post And get Data function gets called")
                        print("Score: \(self.score)")
        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            self.performSegue(withIdentifier: "formToScorePage", sender: self)
                        }
                    }
                }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "formToScorePage"{
            let scorePageValue = segue.destination as! DiabetesScoreViewController
            //print(score)
            scorePageValue.scoreValue = score
            
        }
    }
    
}
