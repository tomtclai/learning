// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct TextEditor_Background: View {
    @State private var text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    
    var body: some View {
        VStack(spacing: 16.0) {
            TextEditor(text: $text)
                .scrollContentBackground(.hidden) // iOS 16
                .padding()
                .background(.indigo.opacity(0.2), in: .rect(cornerRadius: 8))
            
            GroupBox {
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden) // iOS 16
            }
            .backgroundStyle(.teal.opacity(0.2))
        }
        .padding()
        .font(.title)
    }
}

#Preview {
    TextEditor_Background()
}
