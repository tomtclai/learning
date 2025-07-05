// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Text_CustomFontSize_RelativeTo: View {
    @ScaledMetric private var fontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 40) {
            HeaderView("Text",
                       subtitle: "RelativeTo",
                       desc: "You can control how custom or imported fonts scale by using the relativeTo parameter.",
                       back: .green, textColor: .white)
            
            Text("Hello, World!")
                .font(.custom("Avenir Next Bold", size: 26,
                              relativeTo: .largeTitle))
            
            Text("Hello, World!")
                .font(.custom("Nightcall", size: 26,
                              relativeTo: .caption2))
        }
        .font(.title)
    }
}

struct Text_CustomFontSize_RelativeTo_Previews: PreviewProvider {
    static var previews: some View {
        Text_CustomFontSize_RelativeTo()
    }
}
