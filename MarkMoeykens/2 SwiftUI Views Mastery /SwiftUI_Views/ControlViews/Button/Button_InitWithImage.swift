// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Button_InitWithImage: View {
    var body: some View {
        VStack(spacing: 60.0) {
            Button("With Image", image: .bookLogo) { }
            
            Button("With Image", image: .bookLogo) { }
                .buttonStyle(.bordered)
            
            Button("With Image", image: .bookLogo) { }
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(.bordered)
            
            Button("With SF Symbol", systemImage: "paintbrush.pointed.fill") { }
                .buttonStyle(.bordered)
            
            Button("With Image & Role", systemImage: "x.circle", role: .destructive) { }

            Button("With Image & Role", systemImage: "x.circle", role: .destructive) { }
                .buttonStyle(.borderedProminent)
        }
        .controlSize(.extraLarge)
        .font(.title)
    }
}

#Preview {
    Button_InitWithImage()
}
