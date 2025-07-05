// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Gauge_Customizations: View {
    @State private var value = 75.0
    private let minValue = 0.0
    private let maxValue = 100.0
    
    let gradient = Gradient(colors: [.blue, .yellow, .orange, .red])
    
    var body: some View {
        VStack(spacing: 50.0) {
            Gauge(value: value, in: minValue...maxValue) {
                Label("Range", systemImage: "arrow.left.and.right")
            } currentValueLabel: {
                Text(value, format: .number)
            } minimumValueLabel: {
                Text(minValue, format: .number)
            } maximumValueLabel: {
                Text(maxValue, format: .number)
            }
            .tint(gradient) // Doesn't affect labels
            
            Gauge(value: value, in: minValue...maxValue) {
                Text("Color")
            }
            .gaugeStyle(.accessoryCircular)
            .tint(gradient)
            .scaleEffect(3)
            .frame(height: 220)
        }
        .font(.title)
        .padding()
    }
}

struct Gauge_Customizations_Previews: PreviewProvider {
    static var previews: some View {
        Gauge_Customizations()
    }
}
