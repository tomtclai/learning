import SwiftUI

struct NoteSummary: View {
    @Binding var note: Note
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        VStack {
            Text("title")
            TextField("title", text: $note.title)
            Text("body")
            TextField("body", text: $note.body)
            Button("Submit") {
                dismiss()
            }
        }
    }
}

#Preview {
    NoteSummary(note: .constant(Note(title: "My Note", body: "This is a note I wrote")))
}
