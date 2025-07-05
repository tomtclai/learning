// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Chart_AreaMarkStartEnd: View {
    @State private var plots = Schedule.fetchData()
    
    var body: some View {
        Chart(plots) { plot in
            AreaMark(
                x: .value("Employee", plot.employee),
                yStart: .value("Start", plot.hourStart),
                yEnd: .value("End", plot.hourEnd))
            .foregroundStyle(.blue.gradient)
            .interpolationMethod(.cardinal)
        }
        .padding()
        .frame(height: 300)
        .dynamicTypeSize(.xxLarge)
   }
}

struct Chart_AreaMarkStartEnd_Previews: PreviewProvider {
    static var previews: some View {
        Chart_AreaMarkStartEnd()
    }
}
