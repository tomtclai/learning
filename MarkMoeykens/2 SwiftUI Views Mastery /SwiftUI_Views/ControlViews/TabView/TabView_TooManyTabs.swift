//  Created by Mark Moeykens on 7/4/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct TabView_TooManyTabs : View {
    var body: some View {
        TabView {
            Tab("Call", systemImage: "phone") {
                Text("Call Screen")
            }
            
            Tab("Outgoing", systemImage: "phone.arrow.up.right") {
                Text("Outgoing Phone Calls Screen")
            }
            
            Tab("Incoming", systemImage: "phone.arrow.down.left") {
                Text("Incoming Phone Calls Screen")
            }
            
            Tab("Phone Book", systemImage: "book") {
                Text("Phone Book Screen")
            }
            
            Tab("History", systemImage: "clock") {
                Text("History Screen")
            }
            
            Tab("New", systemImage: "phone.badge.plus") {
                Text("New Phone Number")
            }
        }
    }
}

#Preview {
    TabView_TooManyTabs()
}
