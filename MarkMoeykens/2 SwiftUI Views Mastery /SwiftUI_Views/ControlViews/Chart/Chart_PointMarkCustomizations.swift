// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts


struct Chart_PointMarkCustomizations: View {
    @State private var plots = PlotInfo.fetchData()
    
    var body: some View {
        Chart(plots) { plot in
            PointMark(x: .value("Labels", plot.x),
                      y: .value("Values", plot.y))
            .symbol(.diamond)
            .foregroundStyle(by: .value("Values", plot.x))
            .symbolSize(by: .value("Values", plot.y))
        }
        .padding()
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_PointMarkCustomizations_Previews: PreviewProvider {
    static var previews: some View {
        Chart_PointMarkCustomizations()
    }
}
