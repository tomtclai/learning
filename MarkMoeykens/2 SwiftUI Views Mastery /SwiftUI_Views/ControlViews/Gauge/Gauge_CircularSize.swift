// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Gauge_CircularSize: View {
    @State private var progress = 0.25
    
    var body: some View {
        VStack(spacing: 50.0) {
            Gauge(value: progress) {
                Text("Level")
            }
            .gaugeStyle(.accessoryCircular)
            .tint(.orange)
            .scaleEffect(4)
            .frame(width: 250, height: 200)
            
            Gauge(value: progress, label: {})
                .gaugeStyle(.accessoryCircular)
                .tint(.orange)
                .scaleEffect(4)
                .frame(width: 250, height: 200)
                .overlay(alignment: .bottom) {
                    Text("Level")
                        .font(.largeTitle)
                }
        }
    }
}

struct Gauge_CircularSize_Previews: PreviewProvider {
    static var previews: some View {
        Gauge_CircularSize()
    }
}
