// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Scrollview_ContentMargins: View {
    var body: some View {
        VStack {
            ScrollingColorsView()
                .contentMargins(.vertical, 60.0)
                .border(Color.black)
            
            ScrollingColorsView()
                .contentMargins(.bottom, 8, for: .scrollIndicators)
                .border(Color.black)
        }
    }
}


#Preview {
    Scrollview_ContentMargins()
}

struct ScrollingColorsView: View {
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
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
    }
}
