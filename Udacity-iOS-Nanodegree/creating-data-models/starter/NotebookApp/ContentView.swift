//
//  ContentView.swift
//  NotebookApp
//

import SwiftUI
import SwiftData
struct ContentView: View {
    // Change the notes property from a @State variable to a @Query
    @Query private var notes: [Note]
    // TODO: Add an @Environment variable named context to reference the modelContext.
    @Environment(\.modelContext) var context
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                TextField("Search notes...", text: $searchText)
                ForEach(filteredNotes) { note in
                    NoteSummary(note: .constant(note))
                }
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
        // Modify the addNote() function to utilize the insert() method on the context for adding new notes.
        context.insert(Note(title: "New Note", body: "Details..."))
    }
}

#Preview {
    ContentView()
}

