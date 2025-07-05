// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio
import Charts
import SwiftUI

struct Charts_InScrollViews: View {
    let ownership = Share.fetchData()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(1..<5) { quarter in
                    Section("Quarter \(quarter)") {
                        Chart(ownership) { owner in
                            SectorMark(angle: .value("Share", owner.value))
                                .foregroundStyle(by: .value("Owner", owner.label))
                        }
                        .containerRelativeFrame(.vertical, count: 2, span: 1, spacing: 24)
                    }
                }
                .chartLegend(position: .bottom, alignment: .center)
                .dynamicTypeSize(.accessibility2)
            }
            .navigationTitle("Sales")
        }
    }
}

#Preview {
    Charts_InScrollViews()
}
