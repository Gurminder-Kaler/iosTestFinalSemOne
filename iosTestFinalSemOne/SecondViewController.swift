//
//  SecondViewController.swift
//  iosTestFinalSemOne
//
//  Created by Gurminder Singh on 2022-12-15.
//

import UIKit

import FirebaseCore
import FirebaseFirestore

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    let bmiTableIdentifier = "bmiTableIdentifier"
    var bmiList:[List] = []
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewDataToFireBase();
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            let bmiID = self?.bmiList[indexPath.row].id
            self!.db.collection("user").document(bmiID!).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self!.addNewDataToFireBase()
                }
            }
            completionHandler(true)
        }
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    //adding to firebase
    //return none
    func addNewDataToFireBase() {
        let ref = db.collection("user")
        
        ref.getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                bmiList = []
                
                for document in querySnapshot!.documents {
                    bmiList.append(
                        List(
                            id: document.documentID,
                            weight: (document.data()["weight"] as! String),
                            bmi: (document.data()["bmi"] as! Float)
                        )
                    )
                }
                
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bmiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: bmiTableIdentifier)
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: bmiTableIdentifier)
        }
        
        cell?.textLabel?.text = "Weight \(bmiList[indexPath.row].weight) "
        cell?.detailTextLabel?.text = "BMI \(bmiList[indexPath.row].bmi) "
        return cell!
    }
    
    
}
