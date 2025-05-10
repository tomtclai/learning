//
//  MailThreadModel.swift
//  MailApp
//
//  Created by Mark DiFranco on 2024-05-10.
//

import Foundation

struct MailThreadModel: Identifiable {
    let id = UUID()
    let sender: String
    let subject: String
    let date: String
    let content: String
}

extension MailThreadModel {
    static let all: [MailThreadModel] = [
        .udacityEmail,
        .appleEmail,
        .netflixEmail
    ]
}

extension MailThreadModel {
    static let udacityEmail = MailThreadModel(
        sender: "Udacity",
        subject: "How is your SwiftUI course going?",
        date: "4:09 PM",
        content: "Hey! We're just checking in on your progress for the SwiftUI course. Hope you're learning a lot!"
    )
    static let appleEmail = MailThreadModel(
        sender: "Apple",
        subject: "Announcing the all new iPhone 15 Pro",
        date: "9:41 AM",
        content: "We've just launched the new iPhone 15 Pro, and it's our best iPhone yet! Come check it out!"
    )
    static let netflixEmail = MailThreadModel(
        sender: "Netflix",
        subject: "Check out our new shows",
        date: "11:41 AM",
        content: "We have tons of new shows this month, come check them out!"
    )
}
