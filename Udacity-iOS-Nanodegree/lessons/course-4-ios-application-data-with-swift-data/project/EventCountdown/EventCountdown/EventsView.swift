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
            .toolbar(content: {
                NavigationLink(value: Event(id: UUID(), title: "", date: Date.now, textColor: Color.primary)) {
                    Button("Add", systemImage: "plus.app") {}
                }
            })
            .navigationDestination(for: Event.self) { event in
                EventForm(event: event) { updatedEvent in
                    if let index = events.firstIndex(of: event) {
                        events[index] = updatedEvent
                    } else {
                        events.append(updatedEvent)
                        events.sort()
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
