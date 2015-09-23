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
    var audioEngine : AVAudioEngine!
    var audioPlayer : AVAudioPlayer?
    var receivedAudio : RecordedAudio!
    var audioFile : AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filePathURL = receivedAudio.filePathUrl
        try! audioPlayer = AVAudioPlayer(contentsOfURL: filePathURL)
        audioEngine = AVAudioEngine()
        audioPlayer?.enableRate = true
        
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playWithRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playWithRate(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playWithPitch(1000)
    }
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playWithPitch(-1000)
    }
    
    func playWithPitch(pitch: Float) {
        audioPlayer?.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    func playWithRate(rate: Float) {
        audioPlayer?.stop()
        audioEngine.stop()
        audioEngine.reset()
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
