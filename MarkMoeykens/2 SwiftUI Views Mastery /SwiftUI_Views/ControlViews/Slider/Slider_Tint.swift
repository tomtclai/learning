// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Slider_Tint: View {
    @State private var sliderValue = 0.5
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Slider",
                       subtitle: "Tint",
                       desc: "Tint can also be used to change the color of the Slider's track.")
            
            Slider(value: $sliderValue,
                   minimumValueLabel: Image(systemName: "tortoise"),
                   maximumValueLabel: Image(systemName: "hare"), label: {})
                .foregroundStyle(.green)
                .tint(.orange)
                .padding()
        }
        .font(.title)
    }
}

struct Slider_Tint_Previews: PreviewProvider {
    static var previews: some View {
        Slider_Tint()
            .preferredColorScheme(.dark)
    }
}
