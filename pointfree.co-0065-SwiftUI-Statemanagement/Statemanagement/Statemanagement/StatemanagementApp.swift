//
//  StatemanagementApp.swift
//  Statemanagement
//
//  Created by Tom Lai on 4/17/25.
//

import SwiftUI

@main
struct StatemanagementApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(state: AppState())
        }
    }
}
