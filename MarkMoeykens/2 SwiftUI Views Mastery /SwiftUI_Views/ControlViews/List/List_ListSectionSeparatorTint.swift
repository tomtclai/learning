// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct List_ListSectionSeparatorTint: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderView("List",
                       subtitle: "ListSectionSeparatorTint",
                       desc: "Use the listSectionSeparatorTint to modify the color of the separator.")
            
            List {
                Section {
                    Text("Row 1")
                    Text("Row 2")
                    Text("Row 3")
                    Text("Row 4")
                } header: {
                    Text("Section 1")
                }
                .listSectionSeparatorTint(.red)
                
                Section {
                    Text("Row 5")
                    Text("Row 6")
                    Text("Row 7")
                } header: {
                    Text("Section 1")
                }
                .listSectionSeparatorTint(.green, edges: .bottom)
//                .listSectionSeparatorTint(.green, edges: .top) // No effect
                
            }
            .listStyle(.plain) // Bottom only
//            .listStyle(.automatic) // No effect
//            .listStyle(.grouped) // Bottom only
//            .listStyle(.sidebar) // No effect
//            .listStyle(.inset) // Bottom only
//            .listStyle(.insetGrouped) // No effect
        }
        .font(.title)
    }
}

struct List_ListSectionSeparatorTint_Previews: PreviewProvider {
    static var previews: some View {
        List_ListSectionSeparatorTint()
            .preferredColorScheme(.dark)
    }
}
