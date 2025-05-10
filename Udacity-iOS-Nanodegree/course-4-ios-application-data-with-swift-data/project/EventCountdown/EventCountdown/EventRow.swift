//
//  EventRow.swift
//  EventCountdown
//
//  Created by Tom Lai on 5/8/25.
//

import SwiftUI

struct EventRow: View {
    let event: Event
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var currentDate = Date.now

    var formatter: RelativeDateTimeFormatter {
        RelativeDateTimeFormatter()
    }
    var body: some View {
        HStack{
            Text(event.title).font(.title)
                .foregroundStyle(event.textColor)
            Spacer()
            Text(formatter.localizedString(for: event.date, relativeTo: currentDate))
        }
        .onReceive(timer) { input in
            currentDate = input
        }
    }
}

#Preview {
    EventRow(event: Event(id: UUID(), title: "Event title", date: Date.now.advanced(by: 12), textColor: .blue))
}
