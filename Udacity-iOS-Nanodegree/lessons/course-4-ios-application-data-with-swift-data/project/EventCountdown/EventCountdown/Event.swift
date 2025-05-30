//
//  Event.swift
//  EventCountdown
//
//  Created by Tom Lai on 5/8/25.
//

import Foundation
import SwiftUI
struct Event: Comparable, Identifiable, Hashable {
    static func < (lhs: Event, rhs: Event) -> Bool {
        lhs.date < rhs.date
    }
    
    let id: UUID
    let title: String
    let date: Date
    let textColor: Color
}


extension Event {
    static let allEvents: [Event] = [
        Event(
            id: UUID(),
            title: "Morning Team Stand‑up",
            date: Calendar.current.date(byAdding: .minute, value: 1, to: Date())!,
            textColor: .blue
        ),
        Event(
            id: UUID(),
            title: "Coffee with Sarah",
            date: Calendar.current.date(byAdding: .minute, value: 60, to: Date())!,
            textColor: .green
        ),
        Event(
            id: UUID(),
            title: "Project Alpha Deadline",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            textColor: .red
        ),
        Event(
            id: UUID(),
            title: "Dentist Appointment",
            date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!,
            textColor: .orange
        ),
        Event(
            id: UUID(),
            title: "Mom’s Birthday Dinner",
            date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            textColor: .purple
        ),
        Event(
            id: UUID(),
            title: "Yoga Class",
            date: Calendar.current.date(byAdding: .day, value: 6, to: Date())!,
            textColor: .yellow
        ),
        Event(
            id: UUID(),
            title: "UX Design Review",
            date: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
            textColor: .blue
        ),
        Event(
            id: UUID(),
            title: "Car Service",
            date: Calendar.current.date(byAdding: .day, value: 8, to: Date())!,
            textColor: .green
        ),
        Event(
            id: UUID(),
            title: "Client Presentation",
            date: Calendar.current.date(byAdding: .day, value: 9, to: Date())!,
            textColor: .red
        ),
        Event(
            id: UUID(),
            title: "Weekly Grocery Run",
            date: Calendar.current.date(byAdding: .day, value: 10, to: Date())!,
            textColor: .orange
        ),
        Event(
            id: UUID(),
            title: "HR Policy Workshop",
            date: Calendar.current.date(byAdding: .day, value: 11, to: Date())!,
            textColor: .purple
        ),
        Event(
            id: UUID(),
            title: "Visit Grandma",
            date: Calendar.current.date(byAdding: .day, value: 12, to: Date())!,
            textColor: .yellow
        ),
        Event(
            id: UUID(),
            title: "Marketing Team Lunch",
            date: Calendar.current.date(byAdding: .day, value: 13, to: Date())!,
            textColor: .blue
        ),
        Event(
            id: UUID(),
            title: "Quarterly Financial Report Due",
            date: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
            textColor: .green
        ),
        Event(
            id: UUID(),
            title: "Movie Night with Friends",
            date: Calendar.current.date(byAdding: .day, value: 15, to: Date())!,
            textColor: .red
        ),
        Event(
            id: UUID(),
            title: "Parent‑Teacher Conference",
            date: Calendar.current.date(byAdding: .day, value: 16, to: Date())!,
            textColor: .orange
        ),
        Event(
            id: UUID(),
            title: "Webinar: SwiftUI Advanced",
            date: Calendar.current.date(byAdding: .day, value: 17, to: Date())!,
            textColor: .purple
        ),
        Event(
            id: UUID(),
            title: "Anniversary Dinner Reservation",
            date: Calendar.current.date(byAdding: .day, value: 18, to: Date())!,
            textColor: .yellow
        ),
        Event(
            id: UUID(),
            title: "Weekend Hiking Trip",
            date: Calendar.current.date(byAdding: .day, value: 19, to: Date())!,
            textColor: .blue
        ),
        Event(
            id: UUID(),
            title: "Book Club Meeting",
            date: Calendar.current.date(byAdding: .day, value: 20, to: Date())!,
            textColor: .green
        ),
        Event(
            id: UUID(),
            title: "Company Town Hall",
            date: Calendar.current.date(byAdding: .day, value: 21, to: Date())!,
            textColor: .red
        ),
        Event(
            id: UUID(),
            title: "Haircut Appointment",
            date: Calendar.current.date(byAdding: .day, value: 22, to: Date())!,
            textColor: .orange
        ),
        Event(
            id: UUID(),
            title: "Tech Conference Day 1",
            date: Calendar.current.date(byAdding: .day, value: 23, to: Date())!,
            textColor: .purple
        ),
        Event(
            id: UUID(),
            title: "Board Game Night",
            date: Calendar.current.date(byAdding: .day, value: 24, to: Date())!,
            textColor: .yellow
        ),
        Event(
            id: UUID(),
            title: "Final Project Presentation",
            date: Calendar.current.date(byAdding: .day, value: 25, to: Date())!,
            textColor: .blue
        )
    ]
}
