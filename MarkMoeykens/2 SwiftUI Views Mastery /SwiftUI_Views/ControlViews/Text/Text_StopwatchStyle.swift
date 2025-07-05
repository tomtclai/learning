// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
// iOS 18
struct Text_StopwatchStyle: View {
    @State private var currentDate = Date()
    @State private var futureDate = Date().addingTimeInterval(131 * 60)
    
    var body: some View {
        VStack(spacing: 24.0) {
            Text(futureDate, format: .stopwatch(startingAt: currentDate))
            Text(futureDate, format: .stopwatch(startingAt: currentDate, maxFieldCount: 1))
            Text(futureDate, format: .stopwatch(startingAt: currentDate, maxFieldCount: 2))
            Text(futureDate, format: .stopwatch(startingAt: currentDate, maxFieldCount: 3))
            Text(futureDate, format: .stopwatch(startingAt: currentDate, showsHours: false))
            Text(futureDate, format: .stopwatch(startingAt: currentDate, showsHours: false,
                                                maxFieldCount: 1))
        }
        .font(.title)
    }
}

#Preview {
    Text_StopwatchStyle()
}
