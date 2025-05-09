//
//  EventForm.swift
//  EventCountdown
//
//  Created by Tom Lai on 5/8/25.
//

import SwiftUI

struct EventForm: View {
    var event: Event
    @State var title: String = ""
    @State var date: Date = Date.now
    @State var color: Color = .primary
    @State var disabled: Bool = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button("Save") {
            onSave(Event(id: event.id, title: title, date: date, textColor: color))
            dismiss()
        }
        .disabled(title.isEmpty)
        .buttonStyle(.borderedProminent)
        Form {
            TextField("Title", text: $title)
            DatePicker("Date", selection: $date)
            ColorPicker("Color", selection: $color)
        }
        .onAppear {
            title = event.title
            date = event.date
            color = event.textColor
        }

    }
    var onSave:(Event)-> Void
}

#Preview {
    EventForm(event: Event.allEvents.first!) {
        print($0)
    }
}
