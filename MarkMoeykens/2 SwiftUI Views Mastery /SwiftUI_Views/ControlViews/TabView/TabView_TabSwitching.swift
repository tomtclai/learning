//  Created by Mark Moeykens on 7/4/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct TabView_TabSwitching : View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Tab 1", systemImage: "star", value: 1) {
                VStack(spacing: 20) {
                    Button("Go to Tab 2") {
                        selectedTab = 2
                    }
                }
            }
            
            Tab("Tab 2", systemImage: "moon", value: 2) {
                VStack {
                    Text("Second Screen")
                }
            }
        }
        .font(.title)
    }
}

#Preview {
    TabView_TabSwitching()
}
