//
//  ContentView.swift
//  Notes
//
//  Created by Tom Lai on 5/9/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NotesList()
    }
}

#Preview {
    ContentView()
        .environment(Notes(notes:[
        Note(title: "Grocery list",
             body: "Milk, eggs, sourdough, coffee"),
        Note(title: "Team meeting",
             body: "Quarterly planning, Tue 2 PM, Zoom link in calendar"),
        Note(title: "App idea",
             body: "Countdown widget for trips and events"),
        Note(title: "Reading list",
             body: "Finish ‘Swift Concurrency by Example’"),
        Note(title: "Reading list",
             body: "Finish ‘Swift Concurrency by Example’")]
     ))
}
