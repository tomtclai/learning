// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Label_HideShowComponents: View {
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Colors",
                       subtitle: "Hide/Show Components",
                       desc: "You can hide or show the icon or text in Labels using labelStyle.",
                       back: .pink)
            
            VStack(alignment: .leading, spacing: 20) {
                Label("Automatic", systemImage: "camera.badge.ellipsis")
                    .labelStyle(.automatic)
                Label("Icon Only", systemImage: "camera.badge.ellipsis")
                    .labelStyle(.iconOnly)
                Label("Title Only", systemImage: "camera.badge.ellipsis")
                    .labelStyle(.titleOnly)
                Label("Title & Icon", systemImage: "camera.badge.ellipsis")
                    .labelStyle(.titleAndIcon)
            }
        }
        .font(.title)
    }
}

struct Label_HideShowComponents_Previews: PreviewProvider {
    static var previews: some View {
        Label_HideShowComponents()
    }
}
