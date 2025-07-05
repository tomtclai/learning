// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct List_Badge: View {
    var body: some View {
        VStack(spacing: 20.0) {
            List {
                Text("Row 0")
                    .badge(0)
                Text("Row 0")
                    .badge(Text("0"))
                Text("Row 1")
                    .badge(1)
                    .foregroundStyle(.red)
                Text("Row 2")
                    .badge(2)
                    .font(.title3.weight(.bold))
                Text("Row 2")
                    .badge(Text("2").font(.title3.weight(.bold)))
                    .font(.title3.weight(.bold))
                Text("Row 3")
                    .badge(3)
                    .badgeProminence(.decreased)
                Text("Row 4")
                    .badge(4)
                    .badgeProminence(.standard)
                Text("Row 5")
                    .badge(5)
                    .badgeProminence(.increased)
            }
        }
        .font(.title)
    }
}

struct List_Badge_Previews: PreviewProvider {
    static var previews: some View {
        List_Badge()
    }
}
