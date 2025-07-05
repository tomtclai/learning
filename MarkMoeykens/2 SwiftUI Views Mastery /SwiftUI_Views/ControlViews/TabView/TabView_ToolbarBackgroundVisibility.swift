// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
// iOS 18
struct TabView_ToolbarBackgroundVisibility: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                Text("ToolbarBackground Visibility")
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
            
            Tab("Message", systemImage: "envelope") {
                VStack {
                    Text("ToolbarBackground Color")
                }
                .toolbarBackground(.teal.opacity(0.25), for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
        }
        .font(.title)
    }
}

#Preview {
    TabView_ToolbarBackgroundVisibility()
}
