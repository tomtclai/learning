//
//  NotebookAppApp.swift
//  NotebookApp
//
//  Created by Tom Lai on 5/10/25.
//

import SwiftUI

@main
struct NotebookAppApp: App {
    let notes = [Note(title: "My Note", body: "This is a note I wrote"),Note(title: "My Note", body: "This is a note I wrote"),Note(title: "My Note", body: "This is a note I wrote"),Note(title: "My Note", body: "This is a note I wrote")]

    var body: some Scene {
        WindowGroup {
            ContentView(notes: notes)
        }
    }
}
