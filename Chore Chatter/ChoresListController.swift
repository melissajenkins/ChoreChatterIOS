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
    override func viewDidLoad() {
        super.viewDidLoad()
        chores.append(Chore(Title: "Take out the trash", Description: "Some Description here", Points: "100", DueDate: "12/12/2018", ID: 1))
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        //readValues()
        
        self.tableView.reloadData()
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func readValues(){
        chores.removeAll()
        
        let queryString = "SELECT title, description, points, due, id FROM Chores WHERE for = '1'"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error selecting chores: \(error)")
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
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
            let strDate = dateFormatter.string(from: dueDate)
            
            chores.append(Chore(Title: title, Description: description, Points: points, DueDate: strDate, ID: Int(id)))
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier {
        case "CurrentChoreSegue":
            let view = segue.destination as! ViewChoreController
            view.delegate = self
            view.chore = 0
        default:
            print("Default hit")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
