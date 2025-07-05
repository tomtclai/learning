// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct ScrollView_Behavior_ViewAligned: View {
    var items = [Color.green, Color.blue, Color.purple, Color.pink,
                 Color.yellow, Color.orange]
    
    var body: some View {
        ScrollView(Axis.Set.horizontal, showsIndicators: true) {
            HStack(spacing: 0) {
                ForEach(items, id: \.self) { item in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(item)
                        .padding()
                        .containerRelativeFrame(
                            .horizontal,
                            count: 5,
                            span: 4,
                            spacing: 20,
                            alignment: .leading
                        )
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned) // Keeps the target view within the screen
    }
}

#Preview {
    ScrollView_Behavior_ViewAligned()
}
