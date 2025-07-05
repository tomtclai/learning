// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
/*
 iOS 17
 */
struct ScrollView_Behavior_Paging: View {
    var items = [Color.green, Color.blue, Color.purple, Color.pink,
                 Color.yellow, Color.orange]
    
    var body: some View {
        ScrollView(Axis.Set.horizontal, showsIndicators: true) {
            HStack(spacing: 0) {
                ForEach(items, id: \.self) { item in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(item)
                        .padding()
                        .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout() // 1. Set the Target View
        }
        .scrollTargetBehavior(.paging) // 2. Set the Behavior
        .font(.title)
    }
}

#Preview {
    ScrollView_Behavior_Paging()
}
