// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Gauge_Labels: View {
    @State private var value = 0.75
    
    var body: some View {
        VStack(spacing: 100) {
            Gauge(value: value) {
                Text("Range")
            } currentValueLabel: {
                Text(value, format: .number) // number under gauge
            } markedValueLabels: {
                Text("Not currently used")
            }
            
            Gauge(value: value) {
                Text("Range")
            } currentValueLabel: {
                Text(value, format: .number) // number inside gauge
            }
            .gaugeStyle(.accessoryCircularCapacity)
            
            Gauge(value: value) {
                Text("Range")
            } currentValueLabel: {
                Text(value, format: .number)  // number under gauge
            } minimumValueLabel: {
                Text(0, format: .number) // leading
            } maximumValueLabel: {
                Text(100, format: .number) // trailing
            }
            
            Gauge(value: value) {
                Text("Range") // not shown
            } currentValueLabel: {
                Text(value, format: .number)  // not shown
            } minimumValueLabel: {
                Image(systemName: "circle")
            } maximumValueLabel: {
                Image(systemName: "circle.fill")
            }
            .gaugeStyle(.accessoryLinear)
        }
        .tint(.blue)
        .font(.title)
        .padding()
    }
}

struct Gauge_Labels_Previews: PreviewProvider {
    static var previews: some View {
        Gauge_Labels()
    }
}
