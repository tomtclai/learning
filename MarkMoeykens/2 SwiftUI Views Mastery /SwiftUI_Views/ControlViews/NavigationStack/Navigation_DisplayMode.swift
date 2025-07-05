//  Created by Mark Moeykens on 7/20/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Navigation_DisplayMode: View {
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                Spacer()
            }
            .navigationTitle("Inline Display Mode")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Navigation_DisplayMode_Previews: PreviewProvider {
    static var previews: some View {
        Navigation_DisplayMode()
    }
}
