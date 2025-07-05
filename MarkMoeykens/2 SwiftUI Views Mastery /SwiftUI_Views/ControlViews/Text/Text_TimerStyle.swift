// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
// iOS 18
struct Text_TimerStyle: View {
    @State private var tenSeconds = Date().addingTimeInterval(10)
    @State private var currentDate = Date()
    @State private var futureDate = Date().addingTimeInterval(131 * 60)
    
    var body: some View {
        VStack(spacing: 24.0) {
            Text(.currentDate, format: .timer(countingUpIn: currentDate..<tenSeconds))
            Text(.currentDate, format: .timer(countingDownIn: currentDate..<tenSeconds))
            Text(.currentDate, format: .timer(countingDownIn: currentDate..<futureDate))
            Text(.currentDate, format: .timer(countingDownIn: currentDate..<futureDate,
                                              showsHours: false))
            Text(.currentDate, format: .timer(countingDownIn: currentDate..<futureDate,
                                              showsHours: false, maxFieldCount: 1))
            Text(.currentDate, format: .timer(countingDownIn: currentDate..<futureDate,
                                              showsHours: true, maxFieldCount: 2))
        }
        .font(.title)
    }
}

#Preview {
    Text_TimerStyle()
}
