//
//  ContentView.swift
//  Navigation
//
//  Created by Tom Lai on 4/19/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PlayersView()
    }
}
struct PlayersView: View {
    let players = ["Roy Kent",
    "Richard Montlaur",
    "Dani Rojas",
    "Jamie Tartt"]
    var body: some View {
        NavigationStack {
            List(players, id: \.self) { player in
                NavigationLink(player, value: player)
            }
            .navigationDestination(for: String.self, destination: PlayerView.init)
            .navigationTitle("Select player")
        }
    }
}
struct PlayerView: View {
    let name: String
    var body: some View {
        Text("Selected player: \(name)")
            .font(.largeTitle)
    }
}
struct DetailView: View {
    var body: some View {
        Text("Detail View")
    }
}
struct NavContentView: View {
    @State private var title = "Welcome"
    var body: some View {
        VStack {
            NavigationStack {
                VStack{
                    NavigationLink {
                        DetailView()
                    } label: {
                        Label("Show Detail View", systemImage: "globe")
                    }
                }
                    .navigationTitle($title)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("A") {
                                print("About tapped")
                            }
                        }
                        ToolbarItem(placement: .secondaryAction) {
                            Button("B") {
                                print("About tapped")
                            }
                        }
//                        Button("About") {
//                            print("About tapped")
//                        }
//                        Button("Help") {
//                            print("Help tapped")
//                        }
                    }
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
