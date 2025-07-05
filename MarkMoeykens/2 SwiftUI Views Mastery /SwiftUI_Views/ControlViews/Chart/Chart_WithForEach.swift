// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Chart_WithForEach: View {
    @State private var data = [75, 25, 100, 50]
    
    var body: some View {
        Chart {
            ForEach(data, id: \.self) { datum in
                BarMark(x: .value("Labels", "\(datum)"),
                        y: .value("Values", datum))
            }
        }
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_WithForEach_Previews: PreviewProvider {
    static var previews: some View {
        Chart_WithForEach()
    }
}
