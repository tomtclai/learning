// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Chart_BarMarkStacking: View {
    @State private var data = GroupInfo.fetchData()
    
    var body: some View {
        Chart(data) {
            BarMark(
                x: .value("Category", $0.x),
                y: .value("Quantity", $0.y),
                /* Show all examples*/
//                stacking: .center
//                stacking: .normalized
//                stacking: .standard // Default
                stacking: .unstacked
            )
            .foregroundStyle(by: .value("Group", $0.group))
            /* BOOK
             By default bars stack. What if we want side-by-side?
             */
        }
        .padding()
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_BarMarkStacking_Previews: PreviewProvider {
    static var previews: some View {
        Chart_BarMarkStacking()
    }
}
