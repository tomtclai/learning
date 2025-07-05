//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct List_HeaderFooter_InsetGroup: View {
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("List",
                       subtitle: "InsetGrouped: Header & Footer",
                       desc: "This list style also changes the way headers and footers are rendered.",
                       back: .green, textColor: .black)
            List {
                Section {
                    Label("Learn Geography", systemImage: "signpost.right.fill")
                    Label("Learn Music", systemImage: "doc.richtext")
                    Label("Learn Photography", systemImage: "camera.aperture")
                    Label("Learn Art", systemImage: "paintpalette.fill")
                    Label("Learn Physics", systemImage: "atom")
                } header: {
                    Text("What would you like to learn?")
                } footer: {
                    Text("Count: 5")
                }
            }
            .listStyle(.insetGrouped)
        }
        .font(.title)
    }
}

struct List_HeaderFooter_InsetGroup_Previews: PreviewProvider {
    static var previews: some View {
        List_HeaderFooter_InsetGroup()
            .preferredColorScheme(.dark)
    }
}
