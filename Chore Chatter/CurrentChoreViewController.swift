//
//  CurrentChoreViewController.swift
//  Chore Chatter
//
//  Created by Steve Trujillo on 12/5/18.
//  Copyright © 2018 Steve Trujillo. All rights reserved.
//

import UIKit
import AVFoundation

class CurrentChoreViewController: UIViewController {
    @IBAction func FinishChore(_ sender: Any){
        stop()
        guard let path = Bundle.main.url(forResource: "cheer", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            timerSoundEffect = try AVAudioPlayer(contentsOf:path, fileTypeHint: AVFileType.mp3.rawValue)
            guard let timerSoundEffect = timerSoundEffect else { return }
            timerSoundEffect.play()
        }
        catch let error
        {
            print(error.localizedDescription)
        }
        
    }
    @IBOutlet weak var ChoreTitle: UILabel!
    @IBOutlet weak var ChoreTimer: UILabel!
    var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var status: Bool = false
    var delegate: ChoresListController!
    var choreID: Int!
    var timerSoundEffect: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        ChoreTitle.text = delegate.chores[delegate.selectedChore].Title
        ChoreTimer.text = "00:00"
        // Do any additional setup after loading the view, typically from a nib.
        //ChoreTimer.isHidden = true
        start()
        guard let path = Bundle.main.url(forResource: "timer", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            timerSoundEffect = try AVAudioPlayer(contentsOf:path, fileTypeHint: AVFileType.mp3.rawValue)
            guard let timerSoundEffect = timerSoundEffect else { return }
            timerSoundEffect.play()
        }
        catch let error
        {
            print(error.localizedDescription)
        }
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
