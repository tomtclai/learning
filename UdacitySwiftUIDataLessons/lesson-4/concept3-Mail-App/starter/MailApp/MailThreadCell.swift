//
//  MailThreadCell.swift
//  MailApp
//
//  Created by Mark DiFranco on 2024-05-10.
//

import SwiftUI

struct MailThreadCell: View {
    let mailThread: MailThreadModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(mailThread.sender)
                    .font(.title3)
                    .bold()
                Spacer()
                Text(mailThread.date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Text(mailThread.subject)
            Text(mailThread.content)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
    }
}

#Preview {
    List {
        MailThreadCell(mailThread: .udacityEmail)
    }
    .listStyle(.plain)
}
