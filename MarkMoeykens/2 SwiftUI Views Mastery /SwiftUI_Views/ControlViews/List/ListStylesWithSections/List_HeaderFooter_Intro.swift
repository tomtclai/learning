// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct List_HeaderFooter_Intro: View {
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("List Sections",
                       subtitle: "Headers & Footers Intro",
                       desc: "Use the Section view to include headers and footers in a List.",
                       back: .green, textColor: .black)
            List {
                Section {
                    Label("Learn Geography", systemImage: "signpost.right.fill")
                }
                
                Section {
                    Label("Learn Music", systemImage: "doc.richtext")
                } header: {
                    Text("Just a Header")
                }

                Section {
                    Label("Learn Photography", systemImage: "camera.aperture")
                } footer: {
                    Text("(Just a Footer)")
                }
                
                Section {
                    Label("Learn Art", systemImage: "paintpalette.fill")
                    Label("Learn Physics", systemImage: "atom")
                } header: {
                    Text("What would you like to learn?")
                } footer: {
                    Text("Count: 2")
                }
            }
        }
        .font(.title)
    }
}

struct List_HeaderFooter_Intro_Previews: PreviewProvider {
    static var previews: some View {
        List_HeaderFooter_Intro()
            .preferredColorScheme(.dark)
    }
}
