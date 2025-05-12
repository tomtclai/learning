//
//  NotesApp.swift
//  Notes
//
//  Created by Tom Lai on 5/9/25.
//

import SwiftUI

@main
struct NotesApp: App {
    @State var notes: Notes = Notes(notes:[
        Note(title: "Grocery list",
             body: "Milk, eggs, sourdough, coffee"),
        Note(title: "Team meeting",
             body: "Quarterly planning, Tue 2 PM, Zoom link in calendar"),
        Note(title: "App idea",
             body: "Countdown widget for trips and events"),
        Note(title: "Reading list",
             body: "Finish ‘Swift Concurrency by Example’"),
        Note(title: "Birthday plan",
             body: "Reserve dinner at 7 PM, order cake")
    ])
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(notes)
        }
    }
}
