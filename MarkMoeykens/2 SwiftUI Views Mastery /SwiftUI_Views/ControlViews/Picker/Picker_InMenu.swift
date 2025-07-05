// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Picker_InMenu: View {
    enum Reaction: Identifiable, CaseIterable {
        case thumbsup, thumbsdown, heart, questionMark
        var id: Self { self }
    }
    
    @State private var selection: Reaction? = .none
    
    var body: some View {
        Text("Apple example not currently working. Need to set selection to a default value. Selection can't be optional.")
        Menu("Reactions") {
            Picker("Palette", selection: $selection) {
                Label("Thumbs up", systemImage: "hand.thumbsup")
                    .tag(Reaction.thumbsup)
                Label("Thumbs down", systemImage: "hand.thumbsdown")
                    .tag(Reaction.thumbsdown)
                Label("Like", systemImage: "heart")
                    .tag(Reaction.heart)
                Label("Question mark", systemImage: "questionmark")
                    .tag(Reaction.questionMark)
            }
            .pickerStyle(.palette)
            Button("Reply...") {  }
        }
    }
}

#Preview {
    Picker_InMenu()
}
