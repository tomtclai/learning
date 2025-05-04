//
//  EmailSummary.swift
//  navStackLesson
//
//  Created by Tom Lai on 5/4/25.
//

import SwiftUI
struct EmailDeail: View {
    let email: Email
    var body: some View {
        VStack {
            Text("\(email.sender) sent:")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(email.subject)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
            Text(email.body)
                .frame(maxWidth: .infinity, maxHeight: 12, alignment: .leading)
        }
        Spacer()
    }
}
#Preview {
    EmailDeail(email:
                    Email(sender: "David", senderInitials: "DH", subject: "Hello", body: "This is an email thats important for you to read"),
                 
    )
}
