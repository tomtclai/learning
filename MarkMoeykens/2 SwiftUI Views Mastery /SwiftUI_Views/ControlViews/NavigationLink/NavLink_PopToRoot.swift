//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct NavLink_PopToRoot: View {
    @State private var navPath: [String] = []

    var body: some View {
        NavigationStack(path: $navPath) {
            VStack {
                NavigationLink(value: "View 2") {
                    Text("Go to View 2")
                }
            }
            .navigationTitle("Pop to Root")
            .navigationDestination(for: String.self) { pathValue in
                if pathValue == "View 2" {
                    NavLinkView2(navPath: $navPath)
                } else {
                    NavLinkView3(navPath: $navPath)
                }
            }
        }
        .font(.title)
    }
}

struct NavLinkView2: View {
    @Binding var navPath: [String]
    
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink(value: "View 3") {
                Text("Go to View 3")
            }
            
            Text("Nav Path Items:")
            Text(navPath, format: .list(type: .and, width: .short))
        }
        .navigationTitle("View 2")
    }
}

struct NavLinkView3: View {
    @Binding var navPath: [String]
    
    var body: some View {
        VStack {
            Button("Pop to Root View") {
                navPath.removeAll()
            }
            Text("Nav Path Items:")
            Text(navPath, format: .list(type: .and, width: .short))
        }
        .navigationTitle("View 3")
    }
}

struct NavLink_PopToRoot_Previews: PreviewProvider {
    static var previews: some View {
        NavLink_PopToRoot()
    }
}
