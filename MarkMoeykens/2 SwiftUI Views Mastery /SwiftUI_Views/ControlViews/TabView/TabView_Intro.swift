//  Created by Mark Moeykens on 6/26/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct TabView_Intro : View {
    var body: some View {
        TabView {
            Tab {
                Text("Content for the first tab.")
            } label: {
                Text("Tab 1")
            }
            
            Tab {
                Text("Content for the second tab.")
            } label: {
                Text("Tab 2")
            }
        }
        .font(.title)
    }
}

#Preview {
    TabView_Intro()
}
