// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Chart_BarMarkPositionBy: View {
    @State private var data = GroupInfo.fetchData()
    
    var body: some View {
        Chart(data) {
            BarMark(
                x: .value("Category", $0.x),
                y: .value("Quantity", $0.y),
                width: 32,
                /* You can also use .inset(+/- a number) or .ratio(1.1) */
                height: 160 // At this time I'm not sure what height applies to. I tried it on vertical and horizontal bars and see no difference.
            )
            .foregroundStyle(by: .value("Group", $0.group))
            .position(by: .value("Group", $0.group))
        }
        .padding()
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_BarMarkPositionBy_Previews: PreviewProvider {
    static var previews: some View {
        Chart_BarMarkPositionBy()
    }
}
