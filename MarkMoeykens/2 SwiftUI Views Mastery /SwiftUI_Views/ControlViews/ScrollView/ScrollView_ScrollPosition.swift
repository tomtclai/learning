// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
/*
 iOS 17
 */
struct ScrollView_ScrollPosition: View {
    var items = [Color.green, Color.blue, Color.purple, Color.pink,
                 Color.yellow, Color.orange]
    @State private var currentColor: Color? = Color.green
    
    var body: some View {
        VStack(spacing: 24.0) {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(items, id: \.self) { item in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(item)
                            .padding()
                            .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $currentColor)
            
            Text("\(currentColor?.description.capitalized ?? "None")")
            
            Button("Go to Orange") {
                withAnimation {
                    currentColor = Color.orange
                }
            }
        }
        .font(.title)
    }
}

#Preview {
    ScrollView_ScrollPosition()
}
