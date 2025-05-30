//
//  ContentView.swift
//  MailApp
//
//  Created by Mark DiFranco on 2024-05-10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            MailSidebarView()
        } detail: {
            ContentUnavailableView("No Mail", systemImage: "envelope.open")
        }

        // Add a NavigationSplitView here!
        EmptyView()
    }
}

#Preview {
    ContentView()
}
