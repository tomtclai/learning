//
//  NotebookAppApp.swift
//  NotebookApp
//

import SwiftUI
import SwiftData

@main
struct NotebookAppApp: App {
      var body: some Scene {
          WindowGroup {
              ContentView()
          }
          .modelContainer(NotebookContainer.create())
      }
}
