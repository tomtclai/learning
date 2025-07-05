// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Label_Colors: View {
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Colors",
                       subtitle: "ForegroundColor",
                       desc: "Use foregroundStyle to change the icon and text.",
                       back: .pink)

            Label("Camera Settings", systemImage: "camera.badge.ellipsis")
                .foregroundStyle(.pink)
            
            
            DescView(desc: "Divide up the text and icon so you can format them differently.", back: .pink)
            Label {
                Text("Camera Settings")
                    .foregroundStyle(.purple)
            } icon: {
                Image(systemName: "camera.badge.ellipsis")
                    .foregroundStyle(.pink)
            }
        }
        .font(.title)
    }
}

struct Label_Colors_Previews: PreviewProvider {
    static var previews: some View {
        Label_Colors()
    }
}
