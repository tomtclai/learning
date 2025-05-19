//
//  NoteSummary.swift
//  NotebookApp
//
//  Created by V Scarlata on 5/3/24.
//

import SwiftUI

struct NoteSummary: View {
    @Binding var note: Note
    // Declare the @State property for isEditing here default to false
    @State var isEditing: Bool = false

    var body: some View {
         VStack(alignment: .leading) {
             if isEditing {
                 // Add TextField for editing the title
                 // Add TextField for editing the body
                 Button("Save") {
                     // Add action to toggle isEditing state and hide the keyboard
                 }
                 .padding()
             } else {
                 Text(note.title)
                     .fontWeight(.bold)
                 Text(note.body)  
                     .lineLimit(2)
             }
         }
         .padding()
         .background(isEditing ? Color.gray.opacity(0.2) : Color.clear)
         .cornerRadius(10)
         .animation(.default, value: isEditing)
        // Implement an onTapGesture that toggles the isEditing state when the user double-taps the VStack
         .onTapGesture(count: 2) {
             isEditing.toggle()
         }

     }

    // Provide a private method hideKeyboard()

}

#Preview {
    NoteSummary(note: .constant(Note(title: "My Note", body: "This is a note I wrote")))
}
