//  Created by Mark Moeykens on 6/26/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct TabView_Colors: View {
    var body: some View {
        TabView {
            Tab("First", systemImage: "star") {
                Text("First Screen")
            }
            
            Tab("Second", systemImage: "moon") {
                Text("Second Screen")
            }
            
            Tab("Third", systemImage: "sun.min") {
                Text("Third Screen")
            }
        }
        .font(.title)
        .tint(.yellow)
    }
}


#Preview {
    TabView_Colors()
}
