// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Chart_CustomLegend: View {
    @State private var data = GroupInfo.fetchData()

    var body: some View {
        Chart(data) {
            LineMark(
                x: .value("Category", $0.x),
                y: .value("Quantity", $0.y)
            )
            .foregroundStyle(by: .value("Group", $0.group))
        }
        .chartForegroundStyleScale([
            "Rod": .purple,
            "Lem": .orange,
            "Mark": .red /* No data but in Legend */
        ])
        .padding()
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_CustomLegend_Previews: PreviewProvider {
    static var previews: some View {
        Chart_CustomLegend()
    }
}
