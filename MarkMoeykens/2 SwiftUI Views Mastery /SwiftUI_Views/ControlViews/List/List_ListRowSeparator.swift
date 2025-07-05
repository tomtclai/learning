//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct List_ListRowSeparator: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderView("List",
                       subtitle: "Hiding ListRowSeparator",
                       desc: "Use the listRowSeparator to specify if separators are shown or not.")
            
            List {
                Text("Row 1")
                Text("Row 2")
                    .listRowSeparator(.hidden) // top and bottom
                Text("Row 3")
                Text("Row 4")
                Text("Row 5")
                Text("Row 6")
                Text("Row 7")
                    .listRowSeparator(.hidden, edges: .top)
                Text("Row 8")
                Text("Row 9")
                Text("Row 10")
            }
        }
        .font(.title)
    }
}

struct List_ListRowSeparator_Previews: PreviewProvider {
    static var previews: some View {
        List_ListRowSeparator()
            .preferredColorScheme(.dark)
    }
}
