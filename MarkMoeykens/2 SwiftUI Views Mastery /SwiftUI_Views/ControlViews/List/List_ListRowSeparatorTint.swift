//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct List_ListRowSeparatorTint: View {
    var body: some View {
        VStack(spacing: 20.0) {
            HeaderView("List",
                       subtitle: "ListRowSeparatorTint",
                       desc: "Use the listRowSeparatorTint to modify the color of the separator.")
            
            List {
                Text("Row 1")
                Text("Yellow")
                    .listRowSeparatorTint(.yellow) // top and bottom
                Text("Row 3")
                Text("Row 4")
                Text("Row 5")
                Text("Row 6")
                Text("Green on top")
                    .listRowSeparatorTint(.green, edges: .top)
                Text("Row 8")
                Text("Row 9")
                Text("Row 10")
            }
        }
        .font(.title)
    }
}

struct List_ListRowSeparatorTint_Previews: PreviewProvider {
    static var previews: some View {
        List_ListRowSeparatorTint()
            .preferredColorScheme(.dark)
    }
}
