//  Created by Mark Moeykens on 6/5/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct RegularButton : View {
    var body: some View {
        VStack(spacing: 40) {
            Button("Regular Button") {
                // Code here
            }
            
            Button {
                // Code here
            } label: {
                Text("Regular Button")
                    .bold()
            }
        }
        .font(.title) // Make all fonts use the title style
    }
}

#Preview {
    RegularButton()
}
