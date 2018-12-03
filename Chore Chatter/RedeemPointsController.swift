//
//  RedeemPointsController.swift
//  Chore Chatter
//
//  Created by Steve Trujillo on 12/3/18.
//  Copyright © 2018 Steve Trujillo. All rights reserved.
//

import UIKit

class RedeemPointsController: UIViewController {
    
    @IBAction func viewTapped(_ sender: Any) {
        showInputDialog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            // email = alertController.textFields?[1].text
            
            //self.labelMessage.text = "Name: " + name! + "Email: " + email!
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Parent Pin"
            textField.keyboardType = .numberPad

        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
}
