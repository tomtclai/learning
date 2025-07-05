// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Menu_ColoredIcons: View {
    var body: some View {
        Menu("Edit") {
            ControlGroup {
                Button("Add color", image: .eyedropper) { }
                Button("Change Contrast", image: .contrast) { }
            }
            
            Button("Erase", image: .eraser) { }
            Button("Scribble Tool", image: .scribble) { }
        }
        .menuOrder(.fixed)
        .font(.largeTitle)
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    Menu_ColoredIcons()
}
