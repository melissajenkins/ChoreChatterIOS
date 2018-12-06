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
        stop()
    }
    @IBOutlet weak var ChoreTitle: UILabel!
    @IBOutlet weak var ChoreTimer: UILabel!
    var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var status: Bool = false
    var delegate: ViewChoreController!
    var choreID: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //ChoreTimer.isHidden = true
        start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func start() {
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        //timer = Timer.scheduledTimer(timeInterval: 0.1, target: self)
    }
    
    func stop() {
        elapsed = Date().timeIntervalSinceReferenceDate - startTime
        timer?.invalidate()
        status = false
    }
    
    func updateCounter(){
        time = Date().timeIntervalSinceReferenceDate - startTime
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(time)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        ChoreTimer.text = strMinutes + ":" + strSeconds
    }
}
