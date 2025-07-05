// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Picker_WithEnum: View {
    enum EyeColor: String, Identifiable, CaseIterable {
        var id: Self { self }
        case unspecified = "Unspecified"
        case blue  = "Blue"
        case brown = "Brown"
        case hazel  = "Hazel"
    }
    
    @State private var selectedEyeColor = EyeColor.unspecified
    
    var body: some View {
        Form {
            Picker("Eye Color", selection: $selectedEyeColor) {
                ForEach(EyeColor.allCases) { color in
                    Text(color.rawValue)
                }
            }
        }
    }
}

#Preview {
    Picker_WithEnum()
}
