// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Text_MeasurementConversion: View {
    @State private var marathon = Measurement(value: 26.2, unit: UnitLength.miles)
    
    var body: some View {
        VStack(spacing: 24.0) {
            Text(marathon, format: .measurement(width: .wide))
            Text(marathon.converted(to: .feet), format: .measurement(width: .wide))
            Text(marathon.converted(to: .feet), format: .measurement(width: .wide, usage: .asProvided))
        }
        .font(.title)
    }
}

#Preview {
    Text_MeasurementConversion()
}
