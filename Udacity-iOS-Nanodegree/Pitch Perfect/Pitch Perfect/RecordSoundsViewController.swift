//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Tom Lai on 9/23/15.
//  Copyright © 2015 com.udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var microphoneLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    let micBusyMessage = "Recording"
    let micIdleMessage = "Tap to record"
    let micPasuedMessage = "Tap to resume"
    var shouldOverwrite = true

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        pauseButton.hidden = true
        microphoneLabel.text = micIdleMessage
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        microphoneLabel.text = micBusyMessage
        stopButton.hidden = false
        pauseButton.hidden = false
        pauseButton.enabled = true
        sender.enabled = false
        
        
        if (shouldOverwrite)
        {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
            let recordingName = "audio.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            print(filePath)
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        audioRecorder.record()
    }
    
    
    @IBAction func pauseRecording(sender: UIButton) {
        audioRecorder.pause()
        recordButton.enabled = true
        microphoneLabel.text = micPasuedMessage
        sender.enabled = false
        shouldOverwrite = false
    }

    
    
    @IBAction func stopRecording(sender: UIButton) {
        recordButton.enabled = true
        stopButton.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
        // Save recorded audio
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathUrl: recorder.url)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        } else {
            
            print ("Recording was not sucessful")
            
            let alert = UIAlertController(title: "Recording was not sucessful", message: "Try again?", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
            
            recordButton.enabled = true
            stopButton.hidden = true
            pauseButton.hidden = true
            microphoneLabel.text = micIdleMessage
        }
    }
    

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

