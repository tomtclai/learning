//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct TabView_PageTabViewStyle_IndexDisplayMode: View {
    var body: some View {
        TabView {
            Tab {
                Text("PAGE 1")
            }
            Tab {
                Text("PAGE 2")
            }
            Tab {
                Text("PAGE 3")
            }
        }
        .font(.title)
        .tabViewStyle(.page(indexDisplayMode: .never))
        /*
         You can also get rid of the paging index dots using the parameter indexDisplayMode and setting it to .never.
         There is also another option which is .automatic which will only show dots if the TabView has more than one view within it.
         */
    }
}

#Preview {
    TabView_PageTabViewStyle_IndexDisplayMode()
}
