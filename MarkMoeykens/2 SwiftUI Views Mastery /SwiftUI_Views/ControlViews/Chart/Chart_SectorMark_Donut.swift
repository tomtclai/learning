// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import Charts
import SwiftUI

struct Chart_SectorMark_Donut: View {
    let ownership = Share.fetchData()
    
    var body: some View {
        VStack {
            Chart(ownership) { owner in
                SectorMark(angle: .value("Share", owner.value),
                           innerRadius: MarkDimension.fixed(40))
                    .foregroundStyle(by: .value("Owner", owner.label))
            }
            
            Chart(ownership) { owner in
                SectorMark(angle: .value("Share", owner.value),
                           innerRadius: MarkDimension.ratio(0.5),
                           outerRadius: MarkDimension.inset(50))
                .foregroundStyle(by: .value("Owner", owner.label))
            }
        }
        .chartLegend(position: .bottom, alignment: .center)
        .dynamicTypeSize(.accessibility2)
        .padding()
    }
}

#Preview {
    Chart_SectorMark_Donut()
}
