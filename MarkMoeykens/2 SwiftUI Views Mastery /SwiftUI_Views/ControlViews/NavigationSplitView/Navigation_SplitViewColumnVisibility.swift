// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Navigation_SplitViewColumnVisibility: View {
    @State private var visibility = NavigationSplitViewVisibility.all
    
    var body: some View {
        /* BOOK NOTE
         You could also use Binding.constant(.all) to default it to being open.
         */
        NavigationSplitView(columnVisibility: $visibility) {
            Text("Sidebar")
        } detail: {
            VStack {
                Text("Detail")
                Button("Show Sidebar") {
                    visibility = .all
                }
            }
        }
        .font(.title)
    }
}

struct Navigation_SplitViewColumnVisibility_Previews: PreviewProvider {
    static var previews: some View {
        Navigation_SplitViewColumnVisibility()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
