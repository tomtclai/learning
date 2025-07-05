// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Button_TextModifiers : View {
    var body: some View {
        VStack(spacing: 40) {
            Button {} label: {
                Text("Forgot Password?")
                Text("Tap to Recover")
                    .foregroundStyle(.orange)
            }
            
            Button {} label: {
                VStack {
                    Text("New User")
                    Text("(Register Here)").font(.body)
                }
            }
        }
        .font(.title)
    }
}

#Preview {
    Button_TextModifiers()
}
