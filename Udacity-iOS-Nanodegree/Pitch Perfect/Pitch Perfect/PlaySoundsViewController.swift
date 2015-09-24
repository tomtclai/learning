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
    
    @IBAction func playReverbEffect(sender: UIButton) {
        let reverbEffect = AVAudioUnitReverb()
        
        reverbEffect.loadFactoryPreset(.MediumHall)
        reverbEffect.wetDryMix = 50.0
        
        playWithAudioNode(reverbEffect)
        
    }
    
    func playWithPitch(pitch: Float) {
        let changePitchEffect = AVAudioUnitTimePitch()
        
        changePitchEffect.pitch = pitch
        
        playWithAudioNode(changePitchEffect)
    }
    
    func playWithAudioNode(node: AVAudioNode) {
        stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(node)
        
        audioEngine.connect(audioPlayerNode, to: node, format: nil)
        audioEngine.connect(node, to: audioEngine.outputNode, format: nil)
        
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    func playWithRate(rate: Float) {
        stopAllAudio()
        audioPlayer?.rate = rate
        audioPlayer?.currentTime = 0.0
        audioPlayer?.play()
    }

    func stopAllAudio() {
        audioPlayer?.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    @IBAction func stopAudio(sender: UIButton) {
        stopAllAudio()
    }

}
