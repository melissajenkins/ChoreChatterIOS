//
//  EditChoreController.swift
//  Chore Chatter
//
//  Created by Steve Trujillo on 12/5/18.
//  Copyright © 2018 Steve Trujillo. All rights reserved.
//

import UIKit
import SQLite3

class EditChoreController: UIViewController {
    
    @IBOutlet weak var ChoreTitle: UITextField!
    @IBOutlet weak var ChoreDescription: UITextView!
    @IBOutlet weak var ChorePicker: UIDatePicker!
    @IBOutlet weak var EditChoreButton: UIButton!
    @IBOutlet weak var ChorePoints: UITextField!
    @IBAction func EditButton(_ sender: Any) {
        if chore != nil {
            var stmt: OpaquePointer?
            
            if sqlite3_prepare(db, "UPDATE Chores SET user = ?, title = ?, description = ?, points = ?, dueDate = ?, isComplete = ? WHERE id = ?", -1, &stmt, nil) != SQLITE_OK {
                let error = String(cString: sqlite3_errmsg(db)!)
                print("Error creating table: \(error)")
            }
            sqlite3_bind_int(stmt, 1, 0)
            sqlite3_bind_text(stmt, 2, ChoreTitle.text, -1, nil)
            sqlite3_bind_text(stmt, 3, ChoreDescription.text, -1, nil)
            sqlite3_bind_int(stmt, 4, Int32(ChorePoints.text!)!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            sqlite3_bind_text(stmt, 5, dateFormatter.string(from: ChorePicker.date), -1, nil)
            sqlite3_bind_int(stmt, 6, 0)
            sqlite3_bind_int(stmt, 7, Int32(chore))
            
            if sqlite3_step(stmt) != SQLITE_DONE{
                let error = String(cString: sqlite3_errmsg(db)!)
                print("Error inserting row: \(error)")
            }
            
            //self.tableView.reloadData()
            sqlite3_finalize(stmt)
        }
        else {
            var stmt: OpaquePointer?
            
            if sqlite3_prepare(db, "INSERT INTO Chores (user, title, description, points, dueDate, isComplete) VALUES (?, ?, ?, ?, ?, ?)", -1, &stmt, nil) != SQLITE_OK {
                let error = String(cString: sqlite3_errmsg(db)!)
                print("Error creating table: \(error)")
            }
            sqlite3_bind_int(stmt, 1, 0)
            sqlite3_bind_text(stmt, 2, ChoreTitle.text, -1, nil)
            sqlite3_bind_text(stmt, 3, ChoreDescription.text, -1, nil)
            sqlite3_bind_int(stmt, 4, Int32(ChorePoints.text!)!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            sqlite3_bind_text(stmt, 5, dateFormatter.string(from: ChorePicker.date), -1, nil)
            sqlite3_bind_int(stmt, 6, 0)
            
            if sqlite3_step(stmt) != SQLITE_DONE{
                let error = String(cString: sqlite3_errmsg(db)!)
                print("Error inserting row: \(error)")
            }
            
            //self.tableView.reloadData()
            sqlite3_finalize(stmt)
        }
    }
    var delegate: ChoresListController!
    var chore: Int!
    var db: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ChoreChatter.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
        // Do any additional setup after loading the view, typically from a nib.
        if chore != nil
        {
            self.navigationItem.title = "Edit Chore"
            EditChoreButton.setTitle("Edit Chore", for: .normal)
            let queryString = "SELECT * FROM Chores WHERE id = ?"
            var stmt: OpaquePointer?
            
            if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
                let error = String(cString: sqlite3_errmsg(db)!)
                print("Error preparing select: \(error)")
                return
            }
            
            if sqlite3_bind_int(stmt, 1, Int32(chore)) != SQLITE_OK {
                let error = String(cString: sqlite3_errmsg(db)!)
                print("Error binding user ID: \(error)")
                return
            }

            while( sqlite3_step(stmt) == SQLITE_ROW ){
                let id = sqlite3_column_int(stmt, 0)
                let user = sqlite3_column_int(stmt, 1)
                let title = String(cString: sqlite3_column_text(stmt, 2))
                let description = String(cString: sqlite3_column_text(stmt, 3))
                let points = sqlite3_column_int(stmt, 4)
                let dueDate = Date(timeIntervalSince1970: TimeInterval(sqlite3_column_int(stmt, 5)))
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "MM/dd/yyyy" //Specify your format that you want
                let strDate = dateFormatter.string(from: dueDate)
                ChoreTitle.text = title
                ChoreDescription.text = description
                ChorePoints.text = String(points)
            }
        }
        else
        {
            self.navigationItem.title = "Add Chore"
            EditChoreButton.setTitle("Add Chore", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
