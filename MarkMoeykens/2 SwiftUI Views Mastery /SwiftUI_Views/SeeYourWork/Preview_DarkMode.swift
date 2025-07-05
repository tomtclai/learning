//  Created by Mark Moeykens on 9/27/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Preview_DarkMode: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Previews").font(.largeTitle)
            Text("Dark Mode").foregroundStyle(Color.gray)
            Text("By default, your preview will show in light mode. To see it in dark mode, you can use the environment modifier.")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundStyle(Color.white)
            
        }.font(.title)
    }
}

#Preview("Dark") {
    Preview_DarkMode()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    Preview_DarkMode()
        .preferredColorScheme(.light)
}
