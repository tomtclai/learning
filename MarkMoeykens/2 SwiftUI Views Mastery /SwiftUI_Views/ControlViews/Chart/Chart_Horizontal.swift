// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Chart_Horizontal: View {
    var body: some View {
        Chart {
            BarMark(x: .value("Value", 75),
                    y: .value("Label 1", "Day 1"))
            BarMark(x: .value("Value", 25),
                    y: .value("Label 2", "Day 2"))
        }
        .frame(height: 400)
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_Horizontal_Previews: PreviewProvider {
    static var previews: some View {
        Chart_Horizontal()
    }
}
