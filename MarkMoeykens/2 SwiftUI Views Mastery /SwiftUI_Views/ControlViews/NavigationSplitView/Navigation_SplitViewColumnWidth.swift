// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
/* BOOK NOTE
 SwiftUI may use a different width depending on platform, context, and orientation.
 */
struct Navigation_SplitViewColumnWidth: View {
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Text("Sidebar")
                .navigationSplitViewColumnWidth(120)
        } content: {
            Text("Content")
                .navigationSplitViewColumnWidth(min: 900,
                                                ideal: 1000,
                                                max: 1000)
        } detail: {
            Text("Detail")
                .navigationSplitViewColumnWidth(200)
        }
        .navigationSplitViewStyle(.balanced)
        .font(.title)
    }
}

struct Navigation_SplitViewColumnWidth_Previews: PreviewProvider {
    static var previews: some View {
        Navigation_SplitViewColumnWidth()
            .previewDevice("iPad Pro (9.7-inch)")
//            .previewInterfaceOrientation(.landscapeLeft)
    }
}
