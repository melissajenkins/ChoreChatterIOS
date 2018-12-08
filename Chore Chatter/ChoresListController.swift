//
//  ChoresListController.swift
//  Chore Chatter
//
//  Created by Steve Trujillo on 12/6/18.
//  Copyright © 2018 Steve Trujillo. All rights reserved.
//

import UIKit
import SQLite3

class ChoresListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var db: OpaquePointer?
    @IBOutlet weak var tableView: UITableView!
    struct Chore {
        var Title: String;
        var Description: String;
        var Points: String;
        var DueDate: String;
        var ID: Int;
    }
    var chores = [Chore]()
    var selectedChore: Int!
    var user: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ChoreChatter.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
        if isParent() {
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
        else {
            self.navigationItem.leftBarButtonItem?.isEnabled = false
        }
         var stmt: OpaquePointer?
         
         if sqlite3_prepare(db, "INSERT INTO Chores (user, title, description, points, dueDate, isComplete) VALUES (?, ?, ?, ?, ?, ?)", -1, &stmt, nil) != SQLITE_OK {
         let error = String(cString: sqlite3_errmsg(db)!)
         print("Error creating table: \(error)")
         }
         sqlite3_bind_int(stmt, 1, 1)
         sqlite3_bind_text(stmt, 2, "Take out the trash", -1, nil)
         sqlite3_bind_text(stmt, 3, "Take the trash to the street", -1, nil)
         sqlite3_bind_int(stmt, 4, 100)
         sqlite3_bind_text(stmt, 5, "12/12/2018", -1, nil)
         sqlite3_bind_int(stmt, 6, 0)
         
         if sqlite3_step(stmt) != SQLITE_DONE{
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error inserting row: \(error)")
         }
        
        //self.tableView.reloadData()
        sqlite3_finalize(stmt)
        readValues()
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choreCell", for: indexPath)
        cell.textLabel?.text = chores[indexPath.row].Title + " for " + chores[indexPath.row].Points
        cell.detailTextLabel?.text = chores[indexPath.row].Description
        return cell
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection: Int) -> Int {
        return chores.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        selectedChore = chores[indexPath.row].ID
        self.performSegue(withIdentifier: "editChoreSegue", sender: indexPath)
    }
    
    func readValues(){
        chores.removeAll()
        
        let queryString = "SELECT title, description, points, dueDate, id FROM Chores WHERE user = ? AND isComplete = ?"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(error)")
            return
        }
        
        if sqlite3_bind_int(stmt, 1, Int32(user)) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error binding user ID: \(error)")
            return
        }
        
        if sqlite3_bind_int(stmt, 2, 0) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error binding complete: \(error)")
            return
        }
        
        while( sqlite3_step(stmt) == SQLITE_ROW ){
            let title = String(cString: sqlite3_column_text(stmt, 0))
            let description = String(cString: sqlite3_column_text(stmt, 1))
            let points = String(cString: sqlite3_column_text(stmt, 2))
            let dueDate = Date(timeIntervalSince1970: TimeInterval(sqlite3_column_int(stmt, 3)))
            let id = sqlite3_column_int(stmt, 4)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MM/dd/yyyy" //Specify your format that you want
            let strDate = dateFormatter.string(from: dueDate)
            
            chores.append(Chore(Title: title, Description: description, Points: points, DueDate: strDate, ID: Int(id)))
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier {
        case "editChoreSegue":
            if isParent(){
                let view = segue.destination as! EditChoreController
                view.delegate = self
                view.chore = selectedChore
            }
            else{
                let view = segue.destination as! ViewChoreController
                view.delegate = self
                view.chore = selectedChore
            }
            
        case "RedeemPointsSegue":
            let view = segue.destination as! RedeemPointsController
            view.user = user
        default:
            print("Default hit")
        }
    }
    
    func isParent() -> Bool{
        let queryString = "SELECT isParent FROM Users WHERE id = ?"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error selecting items: \(error)")
            return false
        }
        sqlite3_bind_int(stmt, 1, Int32(user))
        while( sqlite3_step(stmt) == SQLITE_ROW ){
            let isParent = sqlite3_column_int(stmt, 0)
            if isParent == 0 {
                return false
            }
            else {
                return true
            }
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
