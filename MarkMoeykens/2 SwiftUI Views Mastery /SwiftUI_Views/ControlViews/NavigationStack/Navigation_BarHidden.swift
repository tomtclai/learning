//  Created by Mark Moeykens on 9/21/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Navigation_BarHidden: View {
    @State private var isHidden = false
    
    var body: some View {
        NavigationStack {
            /*
             Use this modifier if you want to hide the navigation bar. This is helpful when you want to control navigation yourself.
             */
            Toggle("Hide Nav Bar", isOn: $isHidden)
                .font(.title)
                .padding()
                .toolbar(isHidden ? .hidden : .visible)
                .navigationTitle("Hide Me")
        }
    }
}

struct Navigation_BarHidden_Previews: PreviewProvider {
    static var previews: some View {
        Navigation_BarHidden()
    }
}
