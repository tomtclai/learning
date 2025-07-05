// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct List_ListStyle_Plain: View {
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("List",
                       subtitle: "List Style: Plain",
                       desc: "No inset. No rounded borders. No background.",
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
            .tint(.green)
            .listStyle(.plain)
        }
        .font(.title)
    }
}

struct List_ListStyle_Plain_Previews: PreviewProvider {
    static var previews: some View {
        List_ListStyle_Plain()
            .preferredColorScheme(.dark)
    }
}
