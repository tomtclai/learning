// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Chart_ComparingData: View {
    @State private var plots = PlotInfo.fetchData()
    @State private var plots2 = [
        PlotInfo(x: "Quarter 1", y: 50),
        PlotInfo(x: "Quarter 2", y: 35),
        PlotInfo(x: "Quarter 3", y: 75),
        PlotInfo(x: "Quarter 4", y: 65)
    ]

    var body: some View {
        Chart {
            ForEach(plots) { plot in
                LineMark(x: .value("Labels", plot.x),
                         y: .value("Values", plot.y),
                         series: .value("A", "A"))
                .foregroundStyle(Color.red)
            }
            
            ForEach(plots2) { plot in
                LineMark(x: .value("Labels", plot.x),
                         y: .value("Values", plot.y),
                         series: .value("B", "B"))
                .foregroundStyle(Color.purple)
            }
        }
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_ComparingData_Previews: PreviewProvider {
    static var previews: some View {
        Chart_ComparingData()
    }
}
