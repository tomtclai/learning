//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct List_ListStyle_InsetGrouped: View {
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("List",
                       subtitle: "List Style: InsetGrouped",
                       desc: "This list style surrounds your list with padding and puts a rounded rectangle behind it",
                       back: .green, textColor: .black)
                .font(.title)
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
            .tint(.green)
            .listStyle(.insetGrouped)
        }
        .font(.title)
    }
}

struct List_InsetGroupListStyle_Previews: PreviewProvider {
    static var previews: some View {
        List_ListStyle_InsetGrouped()
            .preferredColorScheme(.dark)
    }
}
