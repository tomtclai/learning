// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Chart_MultipleMarks: View {
    @State private var plots = PlotInfo.fetchData()

    var body: some View {
        Chart(plots) { plot in
            LineMark(x: .value("Labels", plot.x),
                     y: .value("Values", plot.y))
                .foregroundStyle(Color.red)

            AreaMark(x: .value("Labels", plot.x),
                     y: .value("Values", plot.y))
                .foregroundStyle(Color.orange.gradient.opacity(0.6))

            PointMark(x: .value("Labels", plot.x),
                      y: .value("Values", plot.y))
        }
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_MultipleMarks_Previews: PreviewProvider {
    static var previews: some View {
        Chart_MultipleMarks()
    }
}
