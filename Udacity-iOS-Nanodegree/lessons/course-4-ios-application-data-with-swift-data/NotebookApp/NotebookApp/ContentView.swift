//
//  ContentView.swift
//  NotebookApp
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Query private var notes: [Note]
    @Environment(\.modelContext) var context
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List {
                TextField("Search notes...", text: $searchText)
                ForEach(filteredNotes) { note in
                    NoteSummary(note: .constant(note))
                }
                .onDelete(perform: deleteNote)
            }
            .navigationTitle("Notes")
            .toolbar {
                Button(action: addNote) {
                    Label("Add Note", systemImage: "plus")
                }
            }
        }
    }

    var filteredNotes: [Note] {
        notes.filter { note in
            searchText.isEmpty || note.title.lowercased().contains(searchText.lowercased())
        }
    }

    private func addNote() {
        context.insert(Note(title: "New Note", body: "Details..."))
    }

    private func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            context.delete(notes[index])
        }
    }
}

#Preview {
    ContentView()
}
