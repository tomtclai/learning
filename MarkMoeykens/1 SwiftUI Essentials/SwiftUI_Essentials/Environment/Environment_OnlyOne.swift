// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

@Observable
class GameOO {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

struct Environment_OnlyOne: View {
    var body: some View {
        NavigationStack {
            NavigationLink("View Game") {
                GameDetailView()
            }
            .navigationTitle("Game")
        }
        .environment(GameOO(name: "Half-Life")) // Only this observable persists in the environment
        .environment(GameOO(name: "Destiny"))
        .font(.title)
    }
}

struct GameDetailView: View {
    @Environment(GameOO.self) private var game
    
    var body: some View {
        Text("Game: \(game.name)")
            .navigationTitle("Game Name")
    }
}

#Preview {
    Environment_OnlyOne()
}
