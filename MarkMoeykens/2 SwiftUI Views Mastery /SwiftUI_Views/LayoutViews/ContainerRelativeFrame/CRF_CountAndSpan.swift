// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct CRF_CountAndSpan: View {
    let colors = [Color.green, Color.blue, Color.purple, Color.pink,
                  Color.yellow, Color.orange]
    
    var body: some View {
        VStack {
            HStack {
                Color.clear
                    .border(.green)
                    .overlay(Text("1"))
                Color.clear
                    .border(.green)
                    .overlay(Text("2"))
                Color.clear
                    .border(.green)
                    .overlay(Text("3"))
                Color.clear
                    .border(.green)
                    .overlay(Text("4"))
                Color.clear
                    .border(.green)
                    .overlay(Text("5"))
            }
            .font(.largeTitle.bold())
            .frame(height: 60)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(colors, id: \.self) { color in
                        color
                            .containerRelativeFrame(.horizontal, count: 5, span: 5, spacing: 8)
                    }
                }
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(colors, id: \.self) { color in
                        color
                            .containerRelativeFrame(.horizontal, count: 5, span: 3, spacing: 8)
                    }
                }
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(colors, id: \.self) { color in
                        color
                            .containerRelativeFrame(.horizontal, count: 5, span: 2, spacing: 8)
                    }
                }
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(colors, id: \.self) { color in
                        color
                            .containerRelativeFrame(.horizontal, count: 5, span: 1, spacing: 8)
                    }
                }
            }
            
            HStack {
                Color.clear
                    .border(.green)
                    .overlay(Text("1"))
                Color.clear
                    .border(.green)
                    .overlay(Text("2"))
                Color.clear
                    .border(.green)
                    .overlay(Text("3"))
                Color.clear
                    .border(.green)
                    .overlay(Text("4"))
                Color.clear
                    .border(.green)
                    .overlay(Text("5"))
            }
            .font(.largeTitle.bold())
            .frame(height: 60)
        }
    }
}

#Preview {
    CRF_CountAndSpan()
}
