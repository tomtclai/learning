// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct MultiDatePicker_Label: View {
    @State private var dates: Set<DateComponents> = []
    
    var body: some View {
        VStack {
            MultiDatePicker(selection: $dates) {
                Text("Pick a Date")
                    .font(.largeTitle.weight(.bold))
            }
            
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

struct MultiDatePicker_Label_Previews: PreviewProvider {
    static var previews: some View {
        MultiDatePicker_Label()
    }
}
