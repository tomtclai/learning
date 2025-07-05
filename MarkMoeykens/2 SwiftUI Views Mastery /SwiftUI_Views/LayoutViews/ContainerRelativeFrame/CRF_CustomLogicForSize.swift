// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct CRF_CustomLogicForSize: View {
    @State private var axis = Axis.Set.horizontal
    
    var body: some View {
        VStack {
            Button("Change Axis") {
                axis = axis == .horizontal ? .vertical : .horizontal
            }
            .font(.title)
            
            Color.green
                .containerRelativeFrame(axis) { length, axis in
                    if axis == .horizontal {
                        // Custom Width
                        return length / 2
                    } else {
                        // Custom Height
                        return length / 1.25
                    }
                }
                .padding()
        }
    }
}

#Preview {
    CRF_CustomLogicForSize()
}
