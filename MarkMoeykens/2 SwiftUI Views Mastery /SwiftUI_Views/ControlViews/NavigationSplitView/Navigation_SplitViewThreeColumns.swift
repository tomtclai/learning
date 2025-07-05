// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Navigation_SplitViewThreeColumns: View {
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Text("Sidebar")
        } content: {
            Text("Content")
        } detail: {
            Text("Detail")
        }
        .font(.title)
    }
}

struct Navigation_SplitViewThreeColumns_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Navigation_SplitViewThreeColumns()
                .previewDisplayName("Default")
            
            Navigation_SplitViewThreeColumns()
                .previewDisplayName("Balanced")
                .navigationSplitViewStyle(.balanced)
            
            Navigation_SplitViewThreeColumns()
                .previewDisplayName("Prominent Detail")
                .navigationSplitViewStyle(.prominentDetail)
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
