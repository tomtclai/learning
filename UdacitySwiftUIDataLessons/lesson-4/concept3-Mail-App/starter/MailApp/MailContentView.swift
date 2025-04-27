//
//  MailContentView.swift
//  MailApp
//
//  Created by Mark DiFranco on 2024-05-10.
//

import SwiftUI

struct MailContentView: View {
    let mailThread: MailThreadModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(mailThread.sender)
                    .font(.title3)
                    .bold()

                Divider()

                Text(mailThread.subject)
                    .font(.title2)
                    .bold()

                Text(mailThread.content)

                HStack(spacing: 20) {
                    Spacer(minLength: 0)

                    Button("Reply", systemImage: "arrowshape.turn.up.left") {
                        // Reply
                    }

                    Button("Reply All", systemImage: "arrowshape.turn.up.left.2") {
                        // Reply All
                    }

                    Button("Archive", systemImage: "archivebox") {
                        // Archive
                    }
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.background.secondary)
            }
            .padding()
        }
        .navigationTitle("1 Message")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MailContentView(mailThread: .udacityEmail)
    }
}
