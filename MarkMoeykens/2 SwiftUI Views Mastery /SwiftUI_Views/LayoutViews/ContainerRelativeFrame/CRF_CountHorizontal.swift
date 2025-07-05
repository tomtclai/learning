// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct CRF_CountHorizontal: View {
    let colors = [Color.green, Color.blue, Color.purple, Color.pink,
                  Color.yellow, Color.orange]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(Array(colors.enumerated()), id: \.1) { index, color in
                    color
                        .opacity(0.7)
                        .containerRelativeFrame(.horizontal, count: 5, span: 1, spacing: 8)
                        .overlay {
                            Text(index + 1, format: .number)
                        }
                }
            }
        }
        .font(.largeTitle)
    }
}

#Preview {
    CRF_CountHorizontal()
}
