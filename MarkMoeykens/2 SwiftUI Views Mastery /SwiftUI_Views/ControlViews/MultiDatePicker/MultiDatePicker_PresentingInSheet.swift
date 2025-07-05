// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct MultiDatePicker_PresentingInSheet: View {
    @State private var showDates = false
    @State private var dates: Set<DateComponents> = []
    
    private var datesArray: [String] {
        dates.sorted { date1, date2 in
            date1.date! < date2.date!
        }.map { date in
            "\(date.month!)/\(date.day!)"
        }
    }
    
    var body: some View {
        VStack {
            LabeledContent("Dates:") {
                Button {
                    showDates = true
                } label: {
                    if dates.count == 0 {
                        Text("Select")
                    } else {
                        Text(datesArray, format: .list(type: .and, width: .short))
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .sheet(isPresented: $showDates) {
            VStack {
                MultiDatePicker("Customizations", selection: $dates)
                
                Button("Done") { showDates = false }
                    .buttonStyle(.borderedProminent)
            }
            .presentationDetents([.medium])
        }
        .font(.title)
    }
}

struct MultiDatePicker_PresentingInSheet_Previews: PreviewProvider {
    static var previews: some View {
        MultiDatePicker_PresentingInSheet()
    }
}
