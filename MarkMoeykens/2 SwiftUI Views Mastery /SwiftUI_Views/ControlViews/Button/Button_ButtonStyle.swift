//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Button_ButtonStyle: View {
    var body: some View {
        VStack(spacing: 80.0) {
            Button("Automatic") { }
                .buttonStyle(.automatic)
            
            Button("Bordered") { }
                .buttonStyle(.bordered)
            
            Button("BorderedProminent") { }
                .buttonStyle(.borderedProminent)
            
            Button("Borderless") { }
                .buttonStyle(.borderless)
            
            Button("Plain") { }
                .buttonStyle(.plain)
        }
        .font(.title)
        .tint(.purple)
    }
}

#Preview {
    Button_ButtonStyle()
}
