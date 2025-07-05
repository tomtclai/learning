// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Toolbar_BackgroundColor: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                ZStack {
                    Color.teal.opacity(0.2)
                        .ignoresSafeArea()
                    
                    Text("Background Color")
                }
            }
            
            Tab("Message", systemImage: "envelope") {
                Text("No Background Color")
            }
        }
        .font(.title)
    }
}

#Preview {
    Toolbar_BackgroundColor()
}
