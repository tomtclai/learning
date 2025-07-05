//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct TabView_PageTabViewStyle_IndexViewStyle: View {
    var body: some View {
        TabView {
            Tab {
                Text("PAGE 1")
                
                Spacer()
                
                Image(systemName: "arrow.down.circle")
                    .padding(.bottom, 45)
            }
            Tab {
                Text("PAGE 2")
            }
            Tab {
                Text("PAGE 3")
            }
        }
        .font(.title)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        /*
         You couldn't see the index dots on the bottom of the screen because it was white-on-white.
         To make the index dots show up better, use the indexViewStyle modifier.
         */
    }
}

#Preview {
    TabView_PageTabViewStyle_IndexViewStyle()
}
