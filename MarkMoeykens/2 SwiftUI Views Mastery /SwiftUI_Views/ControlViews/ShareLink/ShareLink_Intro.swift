// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct ShareLink_Intro: View {
    var body: some View {
        Form {
            Section("Text") {
                ShareLink(item: "Hello and welcome!")
                ShareLink("Share Text", item: "Hello and welcome!")
                ShareLink(item: "Hello and welcome!") {
                    Label("Share Text", systemImage: "square.and.arrow.up.circle")
                }
ShareLink("Share Text", item: "Hello and welcome!",
          subject: Text("Subject"),
          message: Text("This is the message"),
          preview: SharePreview(Text("Share Preview"),
                                image: Image(systemName: "doc.richtext"),
                                icon: Image(systemName: "doc.richtext")))
            }
            
            Section("URL") {
                ShareLink("Share URL", item: URL(string: "bigmountainstudio.com")!)
            }
            
            Section("Collections") {
                ShareLink("Share Collections", items: ["Milk", "Eggs", "Bread"])
            }
            
            Section("Photo") {
                ShareLink(item: Image(systemName: "globe.americas.fill"),
                          preview: SharePreview("The Globe",
                                                image: Image(systemName: "globe.americas.fill"))) {
                    Label("Share Photo", systemImage: "globe.americas.fill")
                }
            }
        }
        .headerProminence(.increased)
        .font(.title)
    }
}

struct ShareLink_Intro_Previews: PreviewProvider {
    static var previews: some View {
        ShareLink_Intro()
    }
}
