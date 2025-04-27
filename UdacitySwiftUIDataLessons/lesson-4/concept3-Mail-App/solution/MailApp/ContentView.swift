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
            ContentUnavailableView(
                "No Mail Selected",
                systemImage: "envelope"
            )
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
