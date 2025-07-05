// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import Charts
import SwiftUI

struct Share: Identifiable {
    let id = UUID()
    let label: String
    let value: Decimal
    
    static func fetchData() -> [Share] {
        [Share(label: "Reagan", value: 35),
         Share(label: "Rod", value: 20),
         Share(label: "Celina", value: 20),
         Share(label: "Tessa", value: 25)]
    }
}

struct Chart_SectorMark: View {
    let ownership = Share.fetchData()
    
    var body: some View {
        VStack {
            Chart(ownership) { owner in
                SectorMark(angle: .value("Share", owner.value),
                angularInset: 4)
                .cornerRadius(8) // Specific for charts
                .blur(radius: owner.label == "Celina" ? 4 : 0)
            }
            .padding(.horizontal)
            
            Chart(ownership) { owner in
                SectorMark(angle: .value("Share", owner.value))
                    .foregroundStyle(by: .value("Owner", owner.label))
            }
        }
        .chartLegend(position: .bottom, alignment: .center)
        .dynamicTypeSize(.accessibility2)
        .padding()
    }
}

#Preview {
    Chart_SectorMark()
}
