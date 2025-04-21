//
//  ContentView.swift
//  Navigation
//
//  Created by Tom Lai on 4/19/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DifferentTypesNavPathView()
    }
}

struct DifferentTypesNavPathView: View {
    
    //@State private var navPath = NavigationPath()
    @StateObject private var pathStore = PathStore()
    //path store enables persisting navigation path
    
    var body: some View {
        NavigationStack(path: $pathStore.path) {
            List(1..<50) { i in
                NavigationLink(value: i) {
                    Label("Row \(i)", systemImage: "\(i).circle")
                }
            }
            .toolbar {
                Button("Random", systemImage: "shuffle") {
                    pathStore.path.append(Int.random(in: 1..<50))
                }
               
            }
            .navigationDestination(for: Int.self) { i in
                Text("Detail \(i)")
                Button("Random", systemImage: "shuffle") {
                    pathStore.path.append(Int.random(in: 1..<50))
                }
                if pathStore.path.count > 1 {
                    Button("Pop to root", systemImage: "home") {
                        while pathStore.path.isEmpty == false {
                            pathStore.path.removeLast()
                        }
                    }
                }
                Text("Nav Stack  \(pathStore.path.codable!)")
            }
            .navigationTitle("Navigation")
        }
        

    }
}

struct NumbersView: View {
    @State private var presentedNumbers = [1]
    var body: some View {
        NavigationStack(path: $presentedNumbers) {
            List(1..<50) { i in
                NavigationLink(value: i) {
                    Label("Row \(i)", systemImage: "\(i).circle")
                }
            }
            .navigationDestination(for: Int.self) { i in
                Text("Detail \(i)")
            }
            .navigationTitle("Navigation")
        }
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
