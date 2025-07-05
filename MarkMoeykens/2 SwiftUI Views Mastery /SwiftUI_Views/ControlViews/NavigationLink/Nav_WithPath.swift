// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Nav_WithPath: View {
    @State private var navPath: [String] = []
    
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack(spacing: 20) {
                NavigationLink(value: "View 2 (from NavLink)") {
                    Text("NavigationLink with Path")
                }

                Button("Button with Paths") {
                    navPath.append("View 2 (from Button)")
                    navPath.append("View 3 (from Button)")
                    navPath.append("View 4 (from Button)")
                }
            }
            .navigationDestination(for: String.self) { pathValue in
                VStack(spacing: 20) {
                    Text("Nav Path Items:")
                    Text(navPath, format: .list(type: .and, width: .short))
                        .italic()
                }
            }
            .navigationTitle("Navigate with Path")
        }
        .font(.title)
    }
}

struct Nav_WithPath_Previews: PreviewProvider {
    static var previews: some View {
        Nav_WithPath()
    }
}
