//
//  ViewChoreController.swift
//  Chore Chatter
//
//  Created by Steve Trujillo on 12/3/18.
//  Copyright © 2018 Steve Trujillo. All rights reserved.
//

import UIKit

class ViewChoreController : UIViewController {
    @IBOutlet weak var ChoreTitle: UILabel!
    @IBOutlet weak var ChorePoints: UILabel!
    @IBOutlet weak var StartTimer: UISwitch!
    @IBAction func startChore(_ sender: Any){
        //self.performSegue(withIdentifier: "choreListSegue", sender: nil)
    }
    var delegate: ChoresListController!
    var chore: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ChoreTitle.text = delegate.chores[chore].Title
        ChorePoints.text = delegate.chores[chore].Points + " points"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier {
        case "ActiveChoreSegue":
            let view = segue.destination as! CurrentChoreViewController
            view.delegate = self
            view.choreID = 0
        default:
            print("Default hit")
        }
    }
}
