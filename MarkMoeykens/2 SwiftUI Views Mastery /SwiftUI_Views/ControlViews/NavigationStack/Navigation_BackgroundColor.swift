//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Navigation_BackgroundColor: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.opacity(0.25)
                    .ignoresSafeArea() // The nav stack is a safe area. This allows color to go BEHIND large nav bar.
                
                Color.gray.opacity(0.25) // The gray does not go into the nav stack area.
            }
            .navigationTitle("Background Color")
        }
    }
}

struct Navigation_IgnoringSafeArea_Previews: PreviewProvider {
    static var previews: some View {
        Navigation_BackgroundColor()
    }
}
