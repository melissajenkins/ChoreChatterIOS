//
//  ViewController.swift
//  Chore Chatter
//
//  Created by Steve Trujillo on 11/26/18.
//  Copyright © 2018 Steve Trujillo. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {    
    var db: OpaquePointer?
    struct User {
        var Name: String;
        var Picture: String;
        var ID: Int32;
        var Parent: Int32;
        var Points: Int32;
    }
    var users = [User]()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 75.0

        self.navigationItem.title = "Select User"
        // Do any additional setup after loading the view, typically from a nib.
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ChoreChatter.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
        var stmt: OpaquePointer?
        if sqlite3_exec(db, "DROP TABLE IF EXISTS Chores", nil, nil, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error pruning table: \(error)")
            return
        }
        if sqlite3_exec(db, "DROP TABLE IF EXISTS Users", nil, nil, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error pruning table: \(error)")
            return
        }
        
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Users (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR, pin VARCHAR, picture VARCHAR, isParent INTEGER, points INTEGER)", nil, nil, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(error)")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Chores (id INTEGER PRIMARY KEY AUTOINCREMENT, user INTEGER, title TEXT, description TEXT, points INTEGER, dueDate TEXT, isComplete INTEGER)", nil, nil, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(error)")
        }
        sqlite3_reset(stmt)
        if sqlite3_prepare(db, "INSERT INTO Users (name, pin, picture, isParent, points) VALUES (?, ?, ?, ?, ?)", -1, &stmt, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(error)")
        }
        sqlite3_bind_text(stmt, 1, "Melissa", -1, nil)
        sqlite3_bind_text(stmt, 2, "1111", -1, nil)
        sqlite3_bind_text(stmt, 3, "test", -1, nil)
        sqlite3_bind_int(stmt, 4, 1)
        sqlite3_bind_int(stmt, 5, 100)
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error inserting row: \(error)")
        }
        
        sqlite3_reset(stmt)
        if sqlite3_prepare(db, "INSERT INTO Users (name, pin, picture, isParent, points) VALUES (?, ?, ?, ?, ?)", -1, &stmt, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(error)")
        }
        
        sqlite3_bind_text(stmt, 1, "Morgan", -1, nil)
        sqlite3_bind_text(stmt, 2, "2222", -1, nil)
        sqlite3_bind_text(stmt, 3, "test", -1, nil)
        sqlite3_bind_int(stmt, 4, 0)
        sqlite3_bind_int(stmt, 5, 100)
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error inserting row: \(error)")
        }
        
        //self.tableView.reloadData()
        sqlite3_finalize(stmt)
        
        readValues()
    }

    func readValues(){
        users.removeAll()
        
        let queryString = "SELECT * FROM Users"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Error selecting users: \(error)")
            return
        }
        
        while( sqlite3_step(stmt) == SQLITE_ROW ){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let _ = String(cString: sqlite3_column_text(stmt, 2)) //user pin
            let picture = String(cString: sqlite3_column_text(stmt, 3))
            let isParent = sqlite3_column_int(stmt, 4)
            let points = sqlite3_column_int(stmt, 5)

            users.append(User(Name: name, Picture: picture, ID: id, Parent: isParent, Points: points))
        }
        users.append(User(Name: "Melissa", Picture: "test", ID:1, Parent: 1, Points: 100))
        users.append(User(Name: "Morgan", Picture: "test", ID:2, Parent: 0, Points: 100))
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserCell
        cell.NameLabel?.text = users[indexPath.row].Name
        cell.Picture?.image = UIImage(named: users[indexPath.row].Picture)
        return cell
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier {
        case "UserCreateSegue":
            print("Temporary debug")
        case "UserLoginSegue":
            let view = segue.destination as! UserLoginController
            view.delegate = self
            view.userSelected = tableView.indexPathForSelectedRow?.row
        default:
            print("Default hit")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
class UserCell: UITableViewCell {
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet var Picture: UIImageView!
}
