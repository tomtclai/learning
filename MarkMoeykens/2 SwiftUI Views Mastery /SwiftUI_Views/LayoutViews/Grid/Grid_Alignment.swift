// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Grid_Alignment: View {
    var body: some View {
        Grid(alignment: .top) {
            GridRow {
                Text("Top")
                Color.blue.opacity(0.5)
            }
            GridRow(alignment: .bottom) {
                Text("Bottom")
                VStack(alignment: .trailing) {
                    Text("Top")
                    Text("Trailing")
                }
                .gridCellAnchor(.topTrailing)
                Color.blue.opacity(0.5)
            }
        }
        .padding()
        .font(.title)
    }
}

struct Grid_Alignment_Previews: PreviewProvider {
    static var previews: some View {
        Grid_Alignment()
    }
}
