// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
/*
 Change to same size of screen.
 */
struct CRF_ScrollView: View {
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0.0) {
                ForEach(1..<10) { item in
                    Rectangle()
                        .fill(.blue.opacity(0.5))
                        .padding()
                        .overlay(Text(item, format: .number).font(.title))
                        .containerRelativeFrame([.horizontal, .vertical])
                }
            }
        }
    }
}

#Preview {
    CRF_ScrollView()
}
