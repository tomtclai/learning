// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct List_RowSpacing: View {
    var body: some View {
        VStack(spacing: 0) {
            List {
                Text("Row 1")
                Text("Row 2")
                Text("Row 3")
                Text("Row 4")
                Text("Row 5")
                    .listRowBackground(Color.pink)
            }
            .listStyle(.plain)
            .listRowSpacing(100)
        }
        .font(.title)
    }
}

#Preview {
    List_RowSpacing()
}
