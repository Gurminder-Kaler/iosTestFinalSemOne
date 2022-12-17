//
//  ViewController.swift
//  ios Test Final Semester One
//
//  Created by Gurminder Singh on 2022-12-14.
//  Student Id : 301294300
//  Dec-14-2022

import UIKit
import FirebaseCore
import FirebaseFirestore

class ViewController: UIViewController {
    
    var bmiValue : Float = 0.0;
    var heightValue : Float = 0.0;
    var weightValue : Float = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var db = Firestore.firestore()
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBAction func genderFieldAction(_ sender: Any) {
    }
    
    @IBOutlet weak var genderFieldOutlet: UISegmentedControl!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBAction func typeFieldAction(_ sender: Any) {
    }
    
    @IBOutlet weak var typeFieldOutlet: UISegmentedControl!
    
    @IBAction func computeBtn(_ sender: Any) {
        
        if (weightTextField.text!.isEmpty || heightTextField.text!.isEmpty) {
            let alertOne =
            UIAlertController(
                title: "Weight/Height cannot be empty",
                message: "Please enter required fields: ",
                preferredStyle: UIAlertController.Style.alert)
            alertOne.addAction(UIAlertAction(title: "Got it", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertOne, animated: true, completion: nil)
        } else {
            
            //Converting values to Float.
            weightValue = (Float(weightTextField.text!)?.rounded())!
            heightValue = (Float(heightTextField.text!)?.rounded())!
            print("weightValue123 \(weightValue)");
            print("heightValue123 \(heightValue)");
            if (typeFieldOutlet.selectedSegmentIndex == 0) {
                print("in meters and kilograms.");
                
                bmiValue = weightValue / (heightValue * heightValue);
                
            } else {
                print("in inches and pounds.");
                
                bmiValue = (weightValue * 703) / (heightValue * heightValue);
                
            }
            
            print("bmiValue123 \(bmiValue)");
            let alertTwo = UIAlertController(title: "Body Mass Index", message: "Your BMI: \(bmiValue)", preferredStyle: UIAlertController.Style.alert)
            
            alertTwo.addAction(UIAlertAction(title: "Got it", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertTwo, animated: true, completion: nil)
            
            print("BMI is: \(ceil(bmiValue * 10) / 10.0) ")
            
        }
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        
        //saving to firebase to persist the data.
        
        if (nameTextField.text!.isEmpty || ageTextField.text!.isEmpty || weightTextField.text!.isEmpty || heightTextField.text!.isEmpty ) {
            
            let alertOne =
            UIAlertController(
                title: "No field can be left empty",
                message: "Please fill all the fields: ",
                preferredStyle: UIAlertController.Style.alert)
            alertOne.addAction(UIAlertAction(title: "Got it", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertOne, animated: true, completion: nil)
            
        } else {
//
//            //Converting values to Float.
//            weightValue = (Float(weightTextField.text!)?.rounded())!
//            heightValue = (Float(heightTextField.text!)?.rounded())!
//            if (typeFieldOutlet.selectedSegmentIndex == 0) {
//                print("in meters and kilograms.");
//
//                bmiValue = weightValue / (heightValue * heightValue);
//            } else {
//                print("in inches and pounds.");
//
//                bmiValue = (weightValue * 703) / (heightValue * heightValue);
//            }
//            let alertTwo = UIAlertController(title: "Body Mass Index", message: "Your BMI: \(bmiValue)", preferredStyle: UIAlertController.Style.alert)
//
//            alertTwo.addAction(UIAlertAction(title: "Got it", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alertTwo, animated: true, completion: nil)
            
            print("BMI is: \(ceil(bmiValue * 10) / 10.0) ")
            db.collection("user").addDocument(data:[
                "name": nameTextField.text!,
                "age": ageTextField.text!,
                "gender": genderFieldOutlet.selectedSegmentIndex,
                "type": typeFieldOutlet.selectedSegmentIndex,
                "height": heightTextField.text!,
                "weight": weightTextField.text!,
                "bmi": bmiValue
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added")
                    let transition = CATransition()
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromTop
                    let stoaryboard = UIStoryboard(name: "Main", bundle: nil)
                    let secondController = stoaryboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
                    self.view.window!.layer.add(transition, forKey: kCATransition)
                    self.present(secondController, animated: false, completion: nil);
                }
            }
        }
        
    }
    
    
}

