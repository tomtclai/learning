// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Button_ButtonBorderShape: View {
    var body: some View {
        VStack(spacing: 80.0) {
            Button("Automatic") { }
                .buttonBorderShape(.automatic)
            
            Button("Capsule") { }
                .buttonBorderShape(.capsule)
            
            Button("Capsule") { }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
            
            Button("RoundedRectangle") { }
                .buttonBorderShape(.roundedRectangle)
            
            Button("Set Radius") { }
                .buttonBorderShape(.roundedRectangle(radius: 24))
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .font(.title)
        .tint(.purple)
    }
}

struct Button_ButtonBorderShape_Previews: PreviewProvider {
    static var previews: some View {
        Button_ButtonBorderShape()
    }
}
