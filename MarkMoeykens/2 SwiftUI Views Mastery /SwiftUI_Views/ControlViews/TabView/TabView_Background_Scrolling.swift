// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct TabView_Background_Scrolling: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                List(0 ..< 7) { item in
                    Text("Row")
                        .padding()
                }
                .scrollContentBackground(.hidden)
                .background(Color.teal.opacity(0.2))
            }
            
            Tab("Message", systemImage: "envelope") {
                Text("No Background Color")
            }
        }
        .font(.title)
    }
}

#Preview {
    TabView_Background_Scrolling()
}
