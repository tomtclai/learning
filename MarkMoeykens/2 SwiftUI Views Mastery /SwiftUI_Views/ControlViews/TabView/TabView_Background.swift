// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct TabView_Background: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                VStack {
                    Text("Home")
                    Spacer()
                    Divider()
                        .background(.ultraThinMaterial)
                }
            }
            
            Tab("Message", systemImage: "envelope") {
                VStack {
                    Text("Messages")
                    Spacer()
                    Divider()
                        .background(Color.brown.opacity(0.5), ignoresSafeAreaEdges: .top)
                }
            }
        }
        .font(.title)
    }
}

#Preview {
    TabView_Background()
        .toolbarBackground(.red, for: .tabBar)
        .preferredColorScheme(.dark)
}
