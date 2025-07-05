// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
/*
 HeaderView("Slider",
 subtitle: "In Menu",
 desc: "You can put a slider within a menu and it will become a stepper.")
 */
struct Slider_InMenu: View {
    @State private var count = 1.0
    @State private var speed = 5.0
    
    var body: some View {
        Menu("Slider in Menu")  {
            Slider(value: $count, in: 1...10, step: 1) {
                Text("Count: \(count, format: .number)")
                    .font(.title)
            }
            
            Slider(value: $speed, in: 1...10, step: 1,
                   minimumValueLabel: Image(systemName: "tortoise"),
                   maximumValueLabel: Image(systemName: "hare")) {
                Text("Speed: \(speed, format: .number)")
            }
            .padding()
        }
        .font(.title)
        .menuOrder(.fixed)
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    Slider_InMenu()
}
