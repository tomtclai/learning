// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Gauge_Range: View {
    @State private var value = 75.0
    private let minValue = 0.0
    private let maxValue = 100.0
    
    var body: some View {
        VStack(spacing: 50.0) {
            Gauge(value: value) {
                Text("No Range")
            }
            
            Gauge(value: value, in: minValue...maxValue) {
                Text("Range")
            }
            
            Gauge(value: value, in: minValue...maxValue) {
                Text("Range")
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(.blue)
        }
        .font(.title)
        .padding()
    }
}

struct Gauge_Range_Previews: PreviewProvider {
    static var previews: some View {
        Gauge_Range()
    }
}
