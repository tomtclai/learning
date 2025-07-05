// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Schedule: Identifiable {
    let id = UUID()
    var employee = ""
    var hourStart = 0
    var hourEnd = 0
    
    static func fetchData() -> [Schedule] {
        [
            Schedule(employee: "Chris", hourStart: 8, hourEnd: 16),
            Schedule(employee: "Rod", hourStart: 7, hourEnd: 15),
            Schedule(employee: "Lem", hourStart: 9, hourEnd: 17),
            Schedule(employee: "Chase", hourStart: 6, hourEnd: 14)
        ]
    }
}

struct Chart_RuleMark: View {
    @State private var plots = Schedule.fetchData()
    
    var body: some View {
        Chart(plots) { plot in
            RuleMark(
                xStart: .value("Start", plot.hourStart),
                xEnd: .value("End", plot.hourEnd),
                y: .value("Employee", plot.employee))
        }
        .padding()
        .frame(height: 300)
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_RuleMark_Previews: PreviewProvider {
    static var previews: some View {
        Chart_RuleMark()
    }
}
