// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Searchable_Completion: View {
    @State private var locationSearch = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20.0) {
                Text("Where do you want to go?")
                    .padding()
                Spacer()
                HeaderView("", subtitle: "SearchCompletion",
                           desc: "Use searchCompletion modifier to associate search terms with views.")
            }
            .font(.title)
            .navigationTitle(Text("Searchable"))
        }
        .searchable(text: $locationSearch) {
            Group {
                HStack {
                    Image(systemName: "house.circle")
                        .font(.largeTitle)
                    Text("Home")
                }
                .searchCompletion("123 Main Street, Salt Lake City, Utah")
                
                HStack {
                    Image(systemName: "building.2.crop.circle")
                        .font(.largeTitle)
                    Text("Work")
                }
                .searchCompletion("456 State Street, Salt Lake City, Utah")
            }
            .font(.title2)
            .tint(.primary)
            .padding(.vertical)
        }
    }
}

struct Searchable_Completion_Previews: PreviewProvider {
    static var previews: some View {
        Searchable_Completion()
    }
}
