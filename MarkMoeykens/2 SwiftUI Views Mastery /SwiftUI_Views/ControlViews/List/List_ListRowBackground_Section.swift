// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct List_ListRowBackground_Section: View {
    var body: some View {
        List {
            Section("Section 1") {
                Text("Item 1")
                Text("Item 2")
                Text("Item 3")
            }
            .listRowBackground(Color.green.opacity(0.2))
            
            Section("Section 2") {
                Text("Item 1")
                Text("Item 2")
                Text("Item 3")
            }
            .listRowBackground(Color.blue.opacity(0.2))

        }
        .headerProminence(.increased)
    }
}

#Preview {
    List_ListRowBackground_Section()
}
