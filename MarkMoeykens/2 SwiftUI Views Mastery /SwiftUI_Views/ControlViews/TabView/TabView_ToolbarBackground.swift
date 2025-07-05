// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
// iOS 16
struct TabView_ToolbarBackground: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                ZStack {
                    Color.teal.opacity(0.2)
                        .ignoresSafeArea()
                    
                    Text("ToolbarBackground Visible")
                }
                .toolbarBackground(.visible, for: .tabBar)
            }
            
            Tab("Message", systemImage: "envelope") {
                Text("ToolbarBackground Hidden")
            }
        }
        .font(.title)
    }
}

#Preview {
    TabView_ToolbarBackground()
}
