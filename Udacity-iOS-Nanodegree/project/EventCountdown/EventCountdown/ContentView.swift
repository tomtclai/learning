//
//  ContentView.swift
//  EventCountdown
//
//  Created by Tom Lai on 5/8/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        EventsView(events: Event.allEvents)
    }
}

#Preview {
    ContentView()
}
