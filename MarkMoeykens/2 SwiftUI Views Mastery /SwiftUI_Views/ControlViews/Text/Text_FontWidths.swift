// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
// iOS 16
struct Text_FontWidths: View {
    var body: some View {
        VStack(spacing: 24.0) {
            Text("Hello, World!")
                .fontWidth(.compressed)
            
            Text("Hello, World!")
                .fontWidth(.condensed)
            
            Text("Hello, World!")
                .fontWidth(.standard)
            
            Text("Hello, World!")
                .fontWidth(.expanded)
            
            Text("Hello, World!")
                .font(.largeTitle.weight(.heavy).width(.compressed))
            
            Text("Hello, World!")
                .fontDesign(.serif)
                .font(.largeTitle.weight(.heavy))
            
            Text("Hello, World!")
                .fontDesign(.serif)
                .font(.largeTitle.weight(.heavy).width(.expanded))
        }
        .font(.largeTitle)
    }
}

#Preview {
    Text_FontWidths()
}
