// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Searchable_Cancel: View {
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
                HeaderView("", subtitle: "Cancel Search",
                           desc: "Here is one way to cancel searching programmatically.")
            }
            .font(.title)
            .navigationTitle(Text("Searchable"))
        }
        .searchable(text: $locationSearch) {
            ForEach(searchResults, id: \.self) { name in
                Button(name) {
                    destination = name
                    locationSearch = ""
                    hideKeyboard()
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

struct Searchable_Cancel_Previews: PreviewProvider {
    static var previews: some View {
        Searchable_Cancel()
    }
}
