//
//  EmailSummary.swift
//  navStackLesson
//
//  Created by Tom Lai on 5/4/25.
//

import SwiftUI
struct EmailSummary: View {
    let email: Email
    var body: some View {
        HStack {
            ZStack {
                Circle().fill(Color.blue)
                    .frame(width: 50)
                Text(email.senderInitials)
                    .font(.title)
                    .foregroundStyle(.white)
            }
            VStack {
                Text(email.subject)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                Text(email.body)
                    .frame(maxWidth: .infinity, maxHeight: 12, alignment: .leading)
            }
        }
    }
}
#Preview {
    EmailSummary(email:
                    Email(sender: "David", senderInitials: "DH", subject: "Hello", body: "This is an email thats important for you to read"),
                 
    )
}
