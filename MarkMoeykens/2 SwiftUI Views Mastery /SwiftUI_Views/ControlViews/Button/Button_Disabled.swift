// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Button_Disabled: View {
    var body: some View {
        VStack(spacing: 60) {
            Button("Enabled") { }
            
            Button("Disabled") { }
                .disabled(true)
            
            Button("Enabled") { }
                .buttonStyle(.bordered)
            
            Button("Disabled") { }
                .buttonStyle(.bordered)
                .disabled(true)
            
            Button("Enabled") { }
                .buttonStyle(.borderedProminent)
            
            Button("Disabled") { }
                .buttonStyle(.borderedProminent)
                .disabled(true)
        }
        .controlSize(.large)
        .font(.title)
        .tint(.purple)
    }
}

struct Button_Disabled_Previews: PreviewProvider {
    static var previews: some View {
        Button_Disabled()
    }
}
