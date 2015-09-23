//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Tom Lai on 9/23/15.
//  Copyright © 2015 com.udacity. All rights reserved.
//

import UIKit
import AVFoundation
class PlaySoundsViewController: UIViewController {
    
    var audioPlayer : AVAudioPlayer?
    var receivedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filePathURL = receivedAudio.filePathUrl
        try! audioPlayer = AVAudioPlayer(contentsOfURL: filePathURL)
        audioPlayer?.enableRate = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: AnyObject) {
        playAtRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: AnyObject) {
        playAtRate(1.5)
    }
    
    func playAtRate(rate: Float) {
        audioPlayer?.stop()
        audioPlayer?.rate = rate
        audioPlayer?.currentTime = 0.0
        audioPlayer?.play()
    }

    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer?.stop()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
