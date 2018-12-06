//
//  UserCreateController.swift
//  Chore Chatter
//
//  Created by Steve Trujillo on 12/5/18.
//  Copyright © 2018 Steve Trujillo. All rights reserved.
//

import UIKit

class UserCreateController: UIViewController {
    
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var UserPin: UITextField!
    @IBOutlet weak var UserPicture: UIImageView!
    @IBOutlet weak var UserIsParent: UISwitch!
    @IBAction func CreateUser(_ sender: Any){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UserIsParent.isOn = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
