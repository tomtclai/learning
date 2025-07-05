//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct List_ListStyle_Sidebar: View {
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("List",
                       subtitle: "List Style: Sidebar",
                       desc: "Using the sidebar list style will remove the separator lines from the list.",
                       back: .green, textColor: .black)
            List {
                Text("What would you like to learn?")
                    .font(.title2)
                    .fontWeight(.bold)
                Label("Learn Geography", systemImage: "signpost.right.fill")
                Label("Learn Music", systemImage: "doc.richtext")
                Label("Learn Photography", systemImage: "camera.aperture")
                Label("Learn Art", systemImage: "paintpalette.fill")
                    .font(Font.system(.title3).weight(.bold))
                Label("Learn Physics", systemImage: "atom")
                Label("Learn 3D", systemImage: "cube.transparent")
                Label("Learn Hair Styling", systemImage: "comb.fill")
            }
            .listStyle(.sidebar)
            .tint(.green)
        }
        .font(.title)
    }
}

struct List_ListStyle_Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        List_ListStyle_Sidebar()
            .preferredColorScheme(.dark)
    }
}
