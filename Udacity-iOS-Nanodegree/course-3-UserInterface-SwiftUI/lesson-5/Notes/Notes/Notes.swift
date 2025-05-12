//
//  Notes.swift
//  Notes
//
//  Created by Tom Lai on 5/11/25.
//

import Foundation
import Observation
@Observable
class Notes {
    var notes: [Note]
    
    init(notes: [Note]) {
        self.notes = notes
    }
    func addNote(_ note: Note) {
        self.notes.append(note)
    }
    
    func append() {
        notes.append(Note(title: "Title", body: "Body"))
    }
    
    func remove(id: UUID) {
        notes = notes.filter { $0.id != id }
    }
    func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
    func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "notes") {
            if let decoded = try? JSONDecoder().decode([Note].self, from: data) {
                self.notes = decoded
            }
        }
    }
}

@Observable
class Note: Identifiable, Hashable, Codable {
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
    

}
