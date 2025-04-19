//
//  Notification.swift
//  pomodoro
//
//  Created by Tom Lai on 4/18/25.
//

import UserNotifications

class PomodoroNotification {
    static func checkAuthorization() async -> Bool {
        let notif = UNUserNotificationCenter.current()
        return await withCheckedContinuation { continuation in
            notif.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized,.provisional,.ephemeral:
                    continuation.resume(returning: true)
                case .notDetermined:
                    
                    notif.requestAuthorization(options: [.alert, .badge, .sound]) { allow, error in
                        continuation.resume(returning: true)
                    }
                    
                case .denied:
                    continuation.resume(returning: false)
                @unknown default:
                    continuation.resume(returning: false)
                }
            }
        }
    }
    static func scheduleNotification(timeInterval: TimeInterval, title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = title
        content.title = body
        content.sound = .default
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: PomodoroAudioSounds.done.resource))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        center.add(UNNotificationRequest(identifier: "PomodoralNotification", content: content, trigger: trigger))
    }
}
