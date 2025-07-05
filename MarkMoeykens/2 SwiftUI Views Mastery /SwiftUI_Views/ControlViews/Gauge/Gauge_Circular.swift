// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Gauge_Circular: View {
    @State private var progress = 0.25

    var body: some View {
        VStack(spacing: 50.0) {
            Gauge(value: progress, label: {})
                .gaugeStyle(.accessoryCircular)
            // instead of default tint, it's the primary color
            
            Gauge(value: progress) {
                Text("Level")
            }
            .gaugeStyle(.accessoryCircular)
            .tint(.orange)
            
            Gauge(value: progress) {
                Text("Level")
                    .padding(5)
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(.red)
        }
    }
}

struct Gauge_Circular_Previews: PreviewProvider {
    static var previews: some View {
        Gauge_Circular()
    }
}
