//
//  NotebookAppApp.swift
//  NotebookApp
//

import SwiftUI
// Import SwiftData

@main
struct NotebookAppApp: App {
    // Initialize the ModelContainer using NotebookContainer

    var body: some Scene {
        WindowGroup {
            // Inject the ModelContainer into ContentView
            ContentView()
        }
        .modelContainer(NotebookContainer.create())
    }
}
