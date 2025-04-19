//
//  ContentView.swift
//  Lists
//
//  Created by Tom Lai on 4/19/25.
//

import SwiftUI
struct ContentView: View {
    var body: some View {
        BookmarkView()
    }
}
struct BookmarkView: View {
    let items: [Bookmark] = [.example1, .example2, .example3]
    var body: some View {
        List(items, children: \.items) { row in
            HStack {
                Image(systemName: row.icon)
                Text(row.name)
            }
        }
    }
}
struct Bookmark: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    var items: [Bookmark]?
    // some example websites
    static let apple = Bookmark(name: "Apple", icon: "1.circle")
    static let bbc = Bookmark(name: "BBC", icon:
                                "square.and.pencil")
    static let swift = Bookmark(name: "Swift", icon: "bolt.fill")
    static let twitter = Bookmark(name: "Twitter", icon: "mic")
    // some example groups
    static let example1 = Bookmark(name: "Favorites", icon:
                                    "star", items: [Bookmark.apple, Bookmark.bbc, Bookmark.swift,
                                                    Bookmark.twitter])
    static let example2 = Bookmark(name: "Recent", icon: "timer",
                                   items: [Bookmark.apple, Bookmark.bbc, Bookmark.swift,
                                           Bookmark.twitter])
    static let example3 = Bookmark(name: "Recommended", icon:
                                    "hand.thumbsup", items: [Bookmark.apple, Bookmark.bbc,
                                                             Bookmark.swift, Bookmark.twitter])
}
struct TasksView: View {
    var body: some View {
        List {
            Section(header: Text("Important")) {
                TaskRow()
            }
            .headerProminence(.increased)
            Section(header: Text("Other"), footer: Text("footer")) {
                TaskRow()
            }
        }
        // inset grouped is the new style
        .listStyle(.insetGrouped)
    }
}

struct TaskRow:View {
    var body: some View {
        Text("Task View")
    }
}
struct UsersView: View {
    @State private var users = ["Glenn", "Malcolm", "Nicola", "Terri"]
    var body: some View {
        NavigationStack {
            List{
                // List does not have onDelete. List is static.
                ForEach(users, id:\.self) { user in
                    Text(user)
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }
            .navigationTitle("Users")
            .toolbar {
                EditButton()
            }
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        users.move(fromOffsets: source, toOffset: destination)
    }
    func delete(at offsets: IndexSet) {
        users.remove(atOffsets: offsets)
    }
}
struct RestaurantView: View {
    let restaurants = [
        Restaurant(name: "Joe's Original"),
        Restaurant(name: "The Real Joe's Original"),
        Restaurant(name: "Original Joe's")
    ]
    var body: some View {
        List (restaurants) { restaurant in
            RestaurantRow(restaurant: restaurant)
        }
    }
}
struct RestaurantRow: View {
    let restaurant: Restaurant
    var body: some View {
        Text("\(restaurant.name)")
    }
}
struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
}
struct Pizzeria: View {
    let name: String
    var body: some View {
        Text("Restaurant: \(name)")
    }
}
#Preview {
    ContentView()
}
