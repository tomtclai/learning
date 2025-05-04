//
//  ContentView.swift
//  navStackLesson
//
//  Created by Tom Lai on 5/4/25.
//

import SwiftUI

struct ContentView: View {
    let emails: [Email]
    var body: some View {
        NavigationStack {
            List(emails, id:\.self) { email in
                NavigationLink(value: email) {
                    EmailSummary(email: email)
                }
            }
            .navigationDestination(for: Email.self, destination: { email in
                EmailDeail(email: email)
            })
        }
        .padding()
    }
}

#Preview {
    ContentView(emails: [
        Email(sender: "David", senderInitials: "DH", subject: "Hello", body: "Its me"),
        Email(sender: "Udacity", senderInitials: "U", subject: "Hello", body: "Its me")
    ])
}
