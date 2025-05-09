//
//  EventsView.swift
//  EventCountdown
//
//  Created by Tom Lai on 5/8/25.
//

import SwiftUI

struct EventsView: View {
    @State var events: [Event]
    var body: some View {
        NavigationStack() {
            List {
                ForEach(events, id: \.self) { event in
                    NavigationLink(value: event) {
                        EventRow(event: event)
                    }
                }
                .onDelete(perform: deleteEvent)
            }
            .navigationDestination(for: Event.self) { event in
                EventForm(event: event) { updatedEvent in
                    if let index = events.firstIndex(of: event) {
                        events[index] = updatedEvent
                    }
                }
            }
        }
    }
    func deleteEvent(at offsets: IndexSet) {
        events.remove(atOffsets: offsets)
    }
}

#Preview {
    EventsView(events: Event.allEvents)
}
