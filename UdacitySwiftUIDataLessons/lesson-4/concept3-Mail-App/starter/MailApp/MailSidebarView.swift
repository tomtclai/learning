//
//  MailSidebarView.swift
//  MailApp
//
//  Created by Mark DiFranco on 2024-05-10.
//

import SwiftUI

struct MailSidebarView: View {
    var body: some View {
        List(MailThreadModel.all) { mailThread in
            // How can we navigate the user to the `MailContentView` when they tap the cell?
            MailThreadCell(mailThread: mailThread)
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("New Email", systemImage: "square.and.pencil") {
                    // Send email
                }
            }
        }
        .navigationTitle("Mail")
    }
}

#Preview {
    NavigationStack {
        MailSidebarView()
    }
}
