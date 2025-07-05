//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Searchable_SearchCompletion: View {
    let names = ["Holly", "Josh", "Rhonda", "Ted", "Holland"]
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(searchResults, id: \.self) { name in
                        NavigationLink(destination: Text(name)) {
                            Text(name)
                        }
                    }
                }
                HeaderView("", subtitle: "SearchCompletion",
                           desc: "Use the searchCompletion modifier to associate what is being typed to another view.")
                    .font(.title)
            }
            .searchable(text: $searchText) {
                ForEach(searchResults, id: \.self) { result in
                    Text("Are you looking for \(result)?")
                        .searchCompletion(result)
                }
            }
            .navigationTitle("Contacts")
        }
    }

    var searchResults: [String] {
        if searchText.isEmpty {
            return names
        } else {
            return names.filter { $0.contains(searchText) }
        }
    }
}

struct Searchable_SearchCompletion_Previews: PreviewProvider {
    static var previews: some View {
        Searchable_SearchCompletion()
            .preferredColorScheme(.dark)
    }
}
