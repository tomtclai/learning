// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Chart_OtherMarks: View {
    @State private var plots = PlotInfo.fetchData()
    
    var body: some View {
        Chart(plots) { plot in
//            LineMark(x: .value("Labels", plot.x),
//                     y: .value("Values", plot.y))
//            AreaMark(x: .value("Labels", plot.x),
//                     y: .value("Values", plot.y))
            PointMark(x: .value("Labels", plot.x),
                      y: .value("Values", plot.y))
            .symbolSize(50) // Doesn't work?
            .symbol(.diamond)
//            .symbolSize(by: .value("Values", plot.y))
//            RectangleMark(x: .value("Labels", plot.x),
//                          y: .value("Values", plot.y))
        }
        .padding()
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_OtherMarks_Previews: PreviewProvider {
    static var previews: some View {
        Chart_OtherMarks()
    }
}
