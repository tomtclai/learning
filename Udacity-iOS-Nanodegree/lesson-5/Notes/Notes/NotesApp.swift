//
//  NotesApp.swift
//  Notes
//
//  Created by Tom Lai on 5/9/25.
//

import SwiftUI

@main
struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(notes: Note.sampleNotes)
        }
    }
}
