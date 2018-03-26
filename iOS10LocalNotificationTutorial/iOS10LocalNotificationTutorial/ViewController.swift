//
//  ViewController.swift
//  iOS10LocalNotificationTutorial
//
//  Created by Tom Lai on 3/26/18.
//  Copyright © 2018 Tom Lai. All rights reserved.
//

import UIKit
import UserNotifications
class ViewController: UIViewController, UNUserNotificationCenterDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: .alert) { (success, error) in
            if success {
                print("success")
            } else {
                print("error")
            }
        }
    }

    @IBAction func sendNotification(_ sender: AnyObject) {
        let content = UNMutableNotificationContent()
        content.title = "30 Min Announcment is due"
//        content.subtitle = "subtitle"
        content.body = "By now the 30 min announcement should have been made by a crew member"
        content.sound = AudioServicePlaySystemSound(1315)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
}

