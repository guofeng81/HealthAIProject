//
//  CalorieViewController.swift
//  HealthAI
//
//  Created by Naresh Kumar on 31/10/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import UIKit
import RealmSwift


class CalorieViewController: UIViewController, UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    let realm = try! Realm()
    
    @IBOutlet weak var goalText: UITextField!
    @IBOutlet weak var caloriesText: UITextField!
    @IBOutlet weak var foodName: UITextField!

    @IBOutlet weak var mealPicker: UIPickerView!
    

    var mealType = ""
    var pickerDataSource = ["Breakfast", "Lunch", "Dinner", "Snacks"]
    

    
    var resultModel : Results<CalorieDataModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        caloriesText.keyboardType = UIKeyboardType.numberPad
        caloriesText.delegate = self
        goalText.delegate = self
        
        loadCalorieHistory()
        self.mealPicker.delegate = self
        self.mealPicker.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func loadCalorieHistory(){
        resultModel = realm.objects(CalorieDataModel.self)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row == 0)//Brackfast
        {
            mealType = "Breakfast"
        }
        else if(row == 1)//Lunch
        {
            mealType = "Lunch"
        }
        else if(row == 2)//Dinner
        {
            mealType = "Dinner"
        }
        else//Snacks
        {
            mealType = "Snacks"
        }
    }
    
    /*
     // MARK: - Navigation
     
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedChar = "1234567890."
        let allowedCharSet = CharacterSet(charactersIn: allowedChar)
        let typedCharSet = CharacterSet(charactersIn: string)
        
        
        return allowedCharSet.isSuperset(of: typedCharSet)
    }
    
    
    
    @IBAction func addButton(_ sender: Any) {
        
                if (foodName.text?.count)! > 0 && (caloriesText.text?.count)! > 0{
        
                    let result = CalorieDataModel()
        
                    result.foodName = foodName.text!
                    result.calorieCount = caloriesText.text!
                    print(mealType)
                    result.mealTypeData = mealType
        
        
                    do{
                        try self.realm.write{
                            self.realm.add(result)
                        }
                    }catch{
                        print("Unable to insert data")
                    }
        
                    foodName.text = ""
                    caloriesText.text = ""
        
        
                    performSegue(withIdentifier: "addtotable", sender: self)
                }
                else{
                    let alert = UIAlertController(title: "Missing Values", message: "Enter Food Name and Calories", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
        
        
    }
    
    @IBAction func CalorieButton(_ sender: Any) {
                foodName.text = ""
                caloriesText.text = ""
                performSegue(withIdentifier: "addtotable", sender: self)
    }
    
    @IBAction func goalButton(_ sender: Any) {
        if (goalText.text?.count)! > 0 {
            
            
            performSegue(withIdentifier: "goaltograph", sender: self)
            
        }else{
            
            let alert = UIAlertController(title: "Enter Goal", message: "Goal Value is missing", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goaltograph"{
            let gvc = segue.destination as! GraphViewController
            gvc.goalValue = Int(goalText.text!)!
            
            let count = resultModel?.count ?? 1
            var countCurrentCalorie = 0
            
            for i in 0...count-1{
                countCurrentCalorie = countCurrentCalorie + Int(resultModel![i].calorieCount)!
            }
            
            gvc.currentValue = countCurrentCalorie
        }
    }
}

