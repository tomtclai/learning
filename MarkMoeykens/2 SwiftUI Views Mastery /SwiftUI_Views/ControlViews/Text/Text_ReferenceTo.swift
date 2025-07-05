// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
// iOS 18
struct Text_ReferenceTo: View {
    @State private var pastDate = Date().addingTimeInterval(-20 * 60)
    @State private var currentDate = Date()
    @State private var futureDate = Date().addingTimeInterval(2 * 24 * 60 * 60)
    
    var body: some View {
        VStack(spacing: 24.0) {
            Text(.currentDate, format: .reference(to: pastDate))
            Text(.currentDate, format: .reference(to: currentDate))
            Text(.currentDate, format: .reference(to: futureDate))
        }
        .font(.title)
    }
}

#Preview {
    Text_ReferenceTo()
}
