// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Navigation_SplitView: View {
    var body: some View {
        NavigationSplitView {
            Text("Sidebar")
                .navigationTitle("NavigationSplitView")
        } detail: {
            Text("Detail")
        }
        .font(.title)
    }
}

struct Navigation_SplitView_Previews: PreviewProvider {
    static var previews: some View {
        Navigation_SplitView()
//            .previewDevice("iPad Pro (9.7-inch)")
//            .previewDevice("iPhone 13")
    }
}
