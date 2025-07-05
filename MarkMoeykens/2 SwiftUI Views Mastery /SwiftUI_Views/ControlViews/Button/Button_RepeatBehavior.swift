// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Button_RepeatBehavior: View {
    @State private var buttonPressedCount = 0
    
    var body: some View {
        HStack(spacing: 60.0) {
            Button("-") {
                buttonPressedCount -= 1
            }
            .buttonRepeatBehavior(.enabled)
            
            Text(buttonPressedCount, format: .number)
            
            Button("+") {
                buttonPressedCount += 1
            }
            .buttonRepeatBehavior(.enabled)
        }
        .buttonStyle(.borderedProminent)
        .font(.title)
    }
}

#Preview {
    Button_RepeatBehavior()
}
