// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts // You need to import the Charts framework (separate from SwiftUI)

struct Chart_Basics: View {
    var body: some View {
        Chart {
            BarMark(x: PlottableValue.value("Label 1", "Day 1"))
            BarMark(x: PlottableValue.value("Label 2", "Day 2"))
        }
        .padding()
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_Basics_Previews: PreviewProvider {
    static var previews: some View {
        Chart_Basics()
    }
}
