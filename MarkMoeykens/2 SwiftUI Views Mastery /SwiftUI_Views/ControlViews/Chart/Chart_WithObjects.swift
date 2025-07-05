// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct PlotInfo: Identifiable {
    let id = UUID()
    var x = ""
    var y = 0
    
    static func fetchData() -> [PlotInfo] {
        [
            PlotInfo(x: "Quarter 1", y: 75),
            PlotInfo(x: "Quarter 2", y: 25),
            PlotInfo(x: "Quarter 3", y: 100),
            PlotInfo(x: "Quarter 4", y: 50)
        ]
    }
}

struct Chart_WithObjects: View {
    @State private var plots = PlotInfo.fetchData()
    
    var body: some View {
        Chart(plots) { plot in
            BarMark(x: .value("Labels", plot.x),
                    y: .value("Values", plot.y))
        }
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_WithObjects_Previews: PreviewProvider {
    static var previews: some View {
        Chart_WithObjects()
    }
}
