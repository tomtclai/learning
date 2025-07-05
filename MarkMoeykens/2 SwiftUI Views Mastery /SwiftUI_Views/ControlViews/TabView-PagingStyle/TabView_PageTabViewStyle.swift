//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct TabView_PageTabViewStyle: View {
    var body: some View {
        TabView {
            Tab {
                Text("PAGE")
                HStack {
                    Image(systemName: "1.circle")
                    Image(systemName: "arrow.right.circle")
                }
            }
            
            Tab {
                Text("PAGE")
                HStack {
                    Image(systemName: "arrow.left.circle")
                    Image(systemName: "2.circle")
                    Image(systemName: "arrow.right.circle")
                }
            }
            Tab {
                Text("PAGE")
                HStack {
                    Image(systemName: "arrow.left.circle")
                    Image(systemName: "3.circle")
                }
            }
        }
        .font(.title)
        .tabViewStyle(.page)
        /*
         The tab view can have a style applied to it which enables the ability to horizontally swipe through views that snap into place.
         */
    }
}

#Preview {
    TabView_PageTabViewStyle()
}
