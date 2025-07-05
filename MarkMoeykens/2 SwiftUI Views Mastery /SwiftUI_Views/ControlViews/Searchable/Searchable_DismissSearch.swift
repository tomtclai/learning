// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Searchable_DismissSearch: View {
    private let locations = ["Milton", "Milltown", "Millerville", "Milwaukee", "Millcreek", "Milagro", "Milano"]
    @State private var searchResults: [String] = []
    @State private var locationSearch = ""
    @State private var destination = ""
    
    var body: some View {
        NavigationStack {
            SearchableSubview(destination: $destination)
        }
        .searchable(text: $locationSearch) {
            ForEach(searchResults, id: \.self) { name in
                Button(name) {
                    destination = name
                }
            }
        }
        .onChange(of: locationSearch) { _, location in
            searchResults = locations.filter { name in
                name.hasPrefix(locationSearch)
            }
        }
    }
}

struct SearchableSubview: View {
    @Binding var destination: String
    @Environment(\.isSearching) var isSearching
    @Environment(\.dismissSearch) var dismissSearch
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Where do you want to go?")
            Text(destination)
                .fontWeight(.bold)
            
            if isSearching && destination.isEmpty == false {
                Button("Confirm") {
                    dismissSearch()
                }
            }
            Spacer()
            HeaderView("", subtitle: "Dismiss Search",
                       desc: "Use the dismissSearch to programmatically cancel searching.")
        }
        .font(.title)
        .navigationTitle(Text("Searchable"))
    }
}

struct Searchable_DismissSearch_Previews: PreviewProvider {
    static var previews: some View {
        Searchable_DismissSearch()
    }
}
