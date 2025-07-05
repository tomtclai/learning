// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct MultiDatePicker_Intro: View {
    @State private var dates: Set<DateComponents> = []
    
    var body: some View {
        VStack {
            MultiDatePicker("Date Range", selection: $dates)

            List {
                Section("Selected Dates") {
                    ForEach(Array(dates), id: \.self) { date in
                        Text("\(date.month!)/\(date.day!)")
                    }
                }
            }
        }
        .font(.title)
    }
}

struct MultiDatePicker_Intro_Previews: PreviewProvider {
    static var previews: some View {
        MultiDatePicker_Intro()
    }
}
