//  Created by Mark Moeykens on 7/4/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct TabView_TabItems : View {
    var body: some View {
        TabView {
            Tab {
                Text("Tab button with just text")
            } label: {
                Text("Tab Text")
            }
            
            Tab("", systemImage: "phone") {
                Text("Tab with just an image")
            }
            
            Tab("Outgoing", systemImage: "phone.arrow.up.right") {
                Text("Tab with text and image")
            }
            
            Tab {
                Text("Tab button using a Label for text and image")
            } label: {
                Label("Messages", systemImage: "phone.badge.waveform")
            }
        }
        .font(.title)
    }
}

#Preview {
    TabView_TabItems()
}
