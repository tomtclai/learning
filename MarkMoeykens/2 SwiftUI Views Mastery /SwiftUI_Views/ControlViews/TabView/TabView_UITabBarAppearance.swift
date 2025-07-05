// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct TabView_UITabBarAppearance: View {
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
        }
        .font(.title)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor(Color.green.opacity(0.2))
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    TabView_UITabBarAppearance()
        .preferredColorScheme(.dark)
}
