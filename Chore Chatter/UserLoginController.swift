//
//  UserLoginController.swift
//  Chore Chatter
//
//  Created by Steve Trujillo on 12/5/18.
//  Copyright © 2018 Steve Trujillo. All rights reserved.
//

import UIKit

class UserLoginController: UIViewController {
    var delegate: ViewController!
    var userSelected: Int!
    @IBOutlet weak var UserPin: UITextField!
    @IBOutlet weak var UserPicture: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBAction func UserLogin(_ sender: Any){
        self.performSegue(withIdentifier: "choreListSegue", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UserName.text = delegate.users[userSelected].Name
        UserPicture.image = UIImage(named: delegate.users[userSelected].Picture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
