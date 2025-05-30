//
//  ContentView.swift
//  Notes
//
//  Created by Tom Lai on 5/9/25.
//

import SwiftUI
import Observation


struct NoteDetail: View {
    @Environment(\.dismiss) var dismiss

    @State var note: Note
    var body: some View {
        Text("Title")
            .font(.title)
        TextField("Title", text: $note.title)
        Text("Note")
            .font(.caption)
        TextEditor(text: $note.body)
        Button("Submit") {
            dismiss()
        }
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

struct NotesList: View {
    @State var searchText: String = ""
    @EnvironmentObject var notes: Notes
    var filteredNotes: [Note] {
        notes.notes.filter { note in
            searchText.isEmpty || note.title.lowercased().contains(searchText.lowercased())
        }
    }
    var body: some View {

        NavigationStack {
            Button("add", systemImage: "plus") {
            notes.append()
        }
            TextField("Search notes...", text: $searchText)
            List(filteredNotes, id: \.self) { note in

                NavigationLink(value: note) {
                    NoteSummary(note: note)
                        .swipeActions {
                            Button(action: { notes.remove(id: note.id)
                            }) {
                                Image(systemName: "trash")
                            }
                        }
                }
            }
            .navigationDestination(for: Note.self) { note in
                NoteDetail(note: note)
            }
        }
    }
}

#Preview {
    NotesList()
}
