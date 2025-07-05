// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Chart_YAxisLabel: View {
    @State private var plots = PlotInfo.fetchData()
    
    var body: some View {
        Chart(plots) { plot in
            BarMark(x: .value("Labels", plot.x),
                    y: .value("Values", plot.y))
        }
        .chartYAxisLabel("Value (a)")
        .chartYAxisLabel {
            Text("Value (b)")
                .font(.title)
                .foregroundStyle(.purple)
                .padding(.bottom)
        }
        .chartYAxisLabel("Value (c)", position: .trailing, alignment: .center, spacing: 8)
        .chartYAxisLabel(position: .bottomTrailing, alignment: .center, spacing: 8) {
            Text("Value (d)")
                .font(.body)
                .foregroundStyle(.red)
        }
        .padding()
        .dynamicTypeSize(.xLarge)
   }
}

struct Chart_YAxisLabel_Previews: PreviewProvider {
    static var previews: some View {
        Chart_YAxisLabel()
    }
}
