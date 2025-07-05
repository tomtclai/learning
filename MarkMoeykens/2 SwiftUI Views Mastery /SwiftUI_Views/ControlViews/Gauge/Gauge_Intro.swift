// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Gauge_Intro: View {
    @State private var progress = 0.25
    
    var body: some View {
        VStack(spacing: 50.0) {
            Gauge(value: progress) {
                Text("Default on iOS")
            }
            
            Gauge(value: progress) {
                Text("linearCapacity") // default
            }
            .gaugeStyle(.linearCapacity)
            .tint(.purple)
            
            Gauge(value: progress) {
                Text("accessoryLinear") // label not shown for this style
            }
            .gaugeStyle(.accessoryLinear)
            .tint(.pink)
            
            Gauge(value: progress) {
                Text("accessoryLinearCapacity")
            }
            .gaugeStyle(.accessoryLinearCapacity)
        }
        .padding(.horizontal)
        .font(.title)
    }
}

struct Gauge_Intro_Previews: PreviewProvider {
    static var previews: some View {
        Gauge_Intro()
    }
}
