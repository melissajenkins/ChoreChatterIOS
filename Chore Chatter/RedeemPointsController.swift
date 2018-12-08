//
//  RedeemPointsController.swift
//  Chore Chatter
//
//  Created by Steve Trujillo on 12/3/18.
//  Copyright © 2018 Steve Trujillo. All rights reserved.
//

import UIKit
import SQLite3

class RedeemPointsController: UIViewController {
    
    var delegate: ViewController!
    var user: Int!
    var db: OpaquePointer?
    var Points: Int!
    @IBOutlet weak var PointsLabel: UILabel!
    @IBOutlet weak var PointsInput: UITextField!
    @IBAction func viewTapped(_ sender: Any) {
        showInputDialog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ChoreChatter.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
        let queryString = "SELECT Points FROM Users WHERE id = ?"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error selecting items: \(error)")
            return
        }
        sqlite3_bind_int(stmt, 1, Int32(user))
        while( sqlite3_step(stmt) == SQLITE_ROW ){
            let points = sqlite3_column_int(stmt, 0)
            
            //items.append(Item(shortDescription: shortDescription, longDescription: longDescription))
            Points = Int(points)
        }
        PointsLabel.text = String(Points)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Enter Parent Pin", message: "Enter your Pin", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            let pin = alertController.textFields?[0].text
            if !self.isParentPin(inputPin: pin!) {
                return
            }
            if let b:Int = Int(self.PointsInput.text!){
                self.Points -= b
                self.updatePoints()
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Parent Pin"
            textField.keyboardType = .numberPad
            textField.maxLength = 4

        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    func isParentPin(inputPin: String) -> Bool {
        let queryString = "SELECT isParent FROM Users WHERE pin = ?"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error selecting items: \(error)")
            return false
        }
        if sqlite3_bind_text(stmt, 1, inputPin, -1, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error selecting items: \(error)")
            return false
        }
        while( sqlite3_step(stmt) == SQLITE_ROW ){
            let isParent = sqlite3_column_int(stmt, 0)
            if isParent == 0 {
                continue
            }
            else {
                return true
            }
        }
        return false
    }
    func updatePoints(){
        let queryString = "UPDATE Users SET Points = ? WHERE id = ?"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error selecting items: \(error)")
            return
        }
        sqlite3_bind_int(stmt, 1, Int32(Points))
        sqlite3_bind_int(stmt, 2, Int32(user))
        if sqlite3_step(stmt) != SQLITE_DONE{
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error updating row: \(error)")
        }
        
        //self.tableView.reloadData()
        sqlite3_finalize(stmt)
    }
    
}
