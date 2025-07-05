// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Chart_Values: View {
    var body: some View {
        Chart {
            BarMark(x: .value("Label 1", "Day 1"),
                    y: .value("Value", 75))
            BarMark(x: .value("Label 2", "Day 2"),
                    y: .value("Value", 25))
        }
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_Intro_Previews: PreviewProvider {
    static var previews: some View {
        Chart_Values()
    }
}
