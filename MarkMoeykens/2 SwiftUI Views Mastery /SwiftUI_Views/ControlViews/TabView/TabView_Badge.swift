// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct TabView_Badge: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                VStack {
                    Text("Home")
                }
            }
            
            Tab("Messages", systemImage: "envelope") {
                VStack {
                    Text("Messages")
                }
            }
            .badge(15)
        }
        .font(.title)
    }
}

#Preview {
    TabView_Badge()
}
