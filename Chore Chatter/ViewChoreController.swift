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
        print(StartTimer.isOn)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ChoreTitle.text = "Take out the trash"
        ChorePoints.text = "100 points"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
