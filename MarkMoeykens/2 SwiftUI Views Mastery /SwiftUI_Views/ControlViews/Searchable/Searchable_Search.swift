// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Searchable_Search: View {
    private let locations = ["Milton", "Milltown", "Millerville", "Milwaukee", "Millcreek", "Milagro", "Milano"]
    @State private var searchResults: [String] = []
    @State private var locationSearch = ""
    @State private var destination = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20.0) {
                Text("Where do you want to go?")
                Text(destination)
                    .fontWeight(.bold)
                Spacer()
                HeaderView("", subtitle: "Searchable",
                           desc: "Use searchable to add a text field to the navigation bar drawer.")
            }
            .font(.title)
            .navigationTitle(Text("Navigation"))
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

struct Searchable_Search_Previews: PreviewProvider {
    static var previews: some View {
        Searchable_Search()
    }
}
