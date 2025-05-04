//
//  navStackLessonApp.swift
//  navStackLesson
//
//  Created by Tom Lai on 5/4/25.
//

import SwiftUI

@main
struct navStackLessonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(emails: [
                Email(sender: "David", senderInitials: "DH", subject: "Hello", body: "Its me"),
                Email(sender: "Udacity", senderInitials: "U", subject: "Hello", body: "Its me")
            ])        }
    }
}
