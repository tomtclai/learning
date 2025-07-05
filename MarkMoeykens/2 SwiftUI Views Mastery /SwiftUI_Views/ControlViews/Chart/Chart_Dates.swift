// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct DailyInfo: Identifiable {
    let id = UUID()
    let x: Date
    let y: Int
    
    static func fetchData() -> [DailyInfo] {
        [
            DailyInfo(x: Date.from(2023, 1, 15), y: 75),
            DailyInfo(x: Date.from(2023, 2, 15), y: 25),
            DailyInfo(x: Date.from(2023, 3, 15), y: 100),
            DailyInfo(x: Date.from(2023, 4, 15), y: 50)
        ]
    }
}

struct Chart_Dates: View {
    @State private var plots = DailyInfo.fetchData()
    
    var body: some View {
        Chart(plots) { plot in
            BarMark(x: .value("Labels", plot.x, unit: .month),
                    y: .value("Values", plot.y))
        }
        .padding()
        .dynamicTypeSize(.xxLarge)
  }
}

extension Date {
    static func from(_ year: Int, _ month: Int, _ day: Int) -> Date
    {
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = DateComponents(calendar: calendar, year: year, month: month, day: day)
        return calendar.date(from: dateComponents)!
    }
}

struct Chart_Dates_Previews: PreviewProvider {
    static var previews: some View {
        Chart_Dates()
    }
}
