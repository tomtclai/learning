// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Chart_XAxisLabel: View {
    @State private var plots = PlotInfo.fetchData()
    
    var body: some View {
        Chart(plots) { plot in
            BarMark(x: .value("Labels", plot.x),
                    y: .value("Values", plot.y))
        }
        .chartXAxisLabel("Quarters (a)")
        .chartXAxisLabel {
            Text("Quarters (b)")
                .font(.title)
                .foregroundStyle(.purple)
                .padding(.top)
        }
        .chartXAxisLabel("Quarters (c)", position: .leading, alignment: .center, spacing: 8)
        .chartXAxisLabel(position: .top, alignment: .center, spacing: 8) {
            Text("Quarters (d)")
                .font(.title3.weight(.bold))
                .frame(width: 300)
                .padding()
                .background(Color.blue.opacity(0.2),
                            in: RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_XAxisLabel_Previews: PreviewProvider {
    static var previews: some View {
        Chart_XAxisLabel()
    }
}
