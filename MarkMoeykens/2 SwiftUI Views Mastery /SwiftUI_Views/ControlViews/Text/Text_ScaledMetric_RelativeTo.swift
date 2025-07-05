// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Text_ScaledMetric_RelativeTo: View {
    @ScaledMetric(wrappedValue: 24, relativeTo: .largeTitle) private var scaleSmall: CGFloat
    @ScaledMetric(wrappedValue: 24, relativeTo: .caption2) private var scaleLarge: CGFloat

    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Text",
                       subtitle: "ScaledMetric - RelativeTo",
                       desc: "Set the relativeTo parameter to control how much the value increases or decreases. Hint: Smaller sizes scale more and smaller sizes scale more.",
                       back: .green, textColor: .white)
            
            Text("Scale This Text Less")
                .font(.system(size: scaleSmall))
            
            Text("Scale This Text More")
                .font(.system(size: scaleLarge))
        }
        .font(.title)
    }
}

struct Text_ScaledMetric_RelativeTo_Previews: PreviewProvider {
    static var previews: some View {
        Text_ScaledMetric_RelativeTo()
    }
}
