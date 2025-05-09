//
//  ContentView.swift
//  Notes
//
//  Created by Tom Lai on 5/9/25.
//

import SwiftUI
import Observation
@Observable class Note: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var body: String
    var starred: Bool
    
    init(id: UUID = UUID(), title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
        self.starred = false
    }
    
    static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static let sampleNotes: [Note] = [
        Note(title: "Grocery list",
             body: "Milk, eggs, sourdough, coffee"),
        Note(title: "Team meeting",
             body: "Quarterly planning, Tue 2 PM, Zoom link in calendar"),
        Note(title: "App idea",
             body: "Countdown widget for trips and events"),
        Note(title: "Reading list",
             body: "Finish ‘Swift Concurrency by Example’"),
        Note(title: "Birthday plan",
             body: "Reserve dinner at 7 PM, order cake")
    ]
}

struct NoteDetail: View {
    @State var note: Note
    var body: some View {
        Text("Title")
            .font(.title)
        TextField("Title", text: $note.title)
        Text("Note")
            .font(.caption)
        TextEditor(text: $note.body)
    }
}

struct NoteSummary: View {
    var note: Note
    var body: some View {
        HStack {
            Group {
                note.starred ? Image(systemName: "star.fill") : Image(systemName: "star")
            }.onTapGesture {
                note.starred.toggle()
            }
            VStack {
                Text(note.title)
                    .font(.headline)
                    .frame(height: 22)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(note.body)
                    .frame(height: 22)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct ContentView: View {
    
    @State var notes: [Note]
    var body: some View {
        Button("add", systemImage: "plus") {
            notes.append(Note(title: "Note note", body: "body"))
        }
        NavigationStack {
            List(notes, id: \.self) { note in
                NavigationLink(value: note) {
                    NoteSummary(note: note)
                }
            }
            .navigationDestination(for: Note.self) { note in
                NoteDetail(note: note)
            }
        }
    }
}

#Preview {
//    NoteDetail(note: Note.sampleNotes.first!)
    ContentView(notes: Note.sampleNotes)
}
