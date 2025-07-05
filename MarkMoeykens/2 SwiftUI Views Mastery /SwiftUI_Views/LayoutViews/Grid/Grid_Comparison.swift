// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Grid_Comparison: View {
    var body: some View {
        VStack {
            HStack {
                Text("Column 1")
                Color.blue
                    .opacity(0.5)
                    .overlay(Text("Column 2"))
                    .frame(height: 50)
            }
            HStack {
                Text("Column 1")
            }
            HStack {
                Text("Column 1")
                Image(systemName: "arrow.left")
            }
        }
        .font(.title)
    }
}

struct Grid_Comparison_Previews: PreviewProvider {
    static var previews: some View {
        Grid_Comparison()
    }
}
