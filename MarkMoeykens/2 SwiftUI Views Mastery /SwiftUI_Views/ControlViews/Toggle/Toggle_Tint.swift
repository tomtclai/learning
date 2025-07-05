// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Toggle_Tint: View {
    @State private var isToggleOn = true
    
    var body: some View {
            VStack(spacing: 40) {
                HeaderView("Toggle",
                           subtitle: "Tint",
                           desc: "Starting in iOS 15, you can use the tint modifier to change the color.")
            
            Group {
                Toggle(isOn: $isToggleOn) {
                    Text("Red")
                    Image(systemName: "paintpalette")
                }
                .tint(.red)
                
                Toggle(isOn: $isToggleOn) {
                    Text("Orange")
                    Image(systemName: "paintpalette")
                }
                .tint(.orange)
            }
            .padding(.horizontal)
        }
        .font(.title)
    }
}

struct Toggle_Tint_Previews: PreviewProvider {
    static var previews: some View {
        Toggle_Tint()
    }
}
