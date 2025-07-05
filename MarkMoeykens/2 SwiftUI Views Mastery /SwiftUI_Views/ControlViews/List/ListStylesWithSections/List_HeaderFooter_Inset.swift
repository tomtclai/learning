// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct List_HeaderFooter_Inset: View {
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("List",
                       subtitle: "Inset - Headers & Footers",
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
            .listStyle(.inset)
        }
        .font(.title)
    }
}

struct List_HeaderFooter_Inset_Previews: PreviewProvider {
    static var previews: some View {
        List_HeaderFooter_Inset()
            .preferredColorScheme(.dark)
    }
}
