//
//  NoteSummary.swift
//  NotebookApp
//
//  Created by V Scarlata on 5/3/24.
//

import SwiftUI

struct NoteSummary: View {
    @Binding var note: Note

    var body: some View {
        VStack {
            TextField("Title", text: $note.title)
            TextField("Body", text: $note.body)
        }
    }
}

#Preview {
    NoteSummary(note: .constant(Note(title: "My Note", body: "This is a note I wrote")))
}
