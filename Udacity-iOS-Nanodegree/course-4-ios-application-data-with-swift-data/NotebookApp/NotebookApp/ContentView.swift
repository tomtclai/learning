import SwiftUI

struct ContentView: View {
    @State var notes: [Note]
    var body: some View {
        List(notes.indices, id:\.self) { index in
            NoteSummary(note: $notes[index])
        }
    }
}

#Preview {
    let notes = [Note(title: "My Note", body: "This is a note I wrote"),Note(title: "My Note", body: "This is a note I wrote"),Note(title: "My Note", body: "This is a note I wrote"),Note(title: "My Note", body: "This is a note I wrote")]
    ContentView(notes: notes)
}
