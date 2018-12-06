//
//  CurrentChoreViewController.swift
//  Chore Chatter
//
//  Created by Steve Trujillo on 12/5/18.
//  Copyright © 2018 Steve Trujillo. All rights reserved.
//

import UIKit

class CurrentChoreViewController: UIViewController {
    @IBAction func FinishChore(_ sender: Any){
        
    }
    @IBOutlet weak var ChoreTitle: UILabel!
    @IBOutlet weak var ChoreTimer: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ChoreTitle.text = "Take out the trash"
        ChoreTimer.text = "00:00"
        ChoreTimer.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
