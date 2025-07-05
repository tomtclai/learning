// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
// iOS 18
struct Text_OffsetStyle: View {
    // Set birthday to March 6, 1991
    @State private var birthday: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.date(from: "1991/03/06") ?? Date()
    }()
    
    var body: some View {
        VStack(spacing: 24.0) {
            Text(Date.now, format: .offset(to: birthday))
            
            Text(Date.now, format: .offset(to: birthday, allowedFields: [.year]))
            
            Text(Date.now, format: .offset(to: birthday, allowedFields: [.year, .month],
                                           maxFieldCount: 1))
        }
        .font(.title)
    }
}

#Preview {
    Text_OffsetStyle()
}
