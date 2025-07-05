// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts

struct Chart_WithData: View {
    @State private var data = [75, 25, 100, 50]
    
    var body: some View {
        Chart(data, id: \.self) { datum in
            BarMark(x: .value("Labels", "\(datum)"),
                    y: .value("Values", datum))
        }
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_WithData_Previews: PreviewProvider {
    static var previews: some View {
        Chart_WithData()
    }
}
