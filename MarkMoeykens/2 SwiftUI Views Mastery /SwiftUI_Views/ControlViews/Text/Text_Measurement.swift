// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Text_Measurement: View {
    @State private var marathon = Measurement(value: 26.2, unit: UnitLength.miles)
    @State private var height = Measurement(value: 2, unit: UnitLength.meters)
    @State private var temperature = Measurement(value: 30, unit: UnitTemperature.celsius)

    var body: some View {
        VStack(spacing: 10) {
            HeaderView("Text",
                       subtitle: "Measurement",
                       desc: "Use the format parameter with different types such as Measurement.",
                       back: .green, textColor: .white)
            
            Text(marathon, format: .measurement(width: .narrow))
            Text(marathon, format: .measurement(width: .abbreviated))
            Text(marathon, format: .measurement(width: .wide))
            
            DescView(desc: "The format is also locale-aware by default.",
                     back: .green, textColor: .white)
            Text(height, format: .measurement(width: .wide))
            Text(temperature, format: .measurement(width: .abbreviated))
            
            DescView(desc: "Specify usage to prevent locale-aware.",
                     back: .green, textColor: .white)
            Text(height, format: .measurement(width: .wide, usage: .asProvided))
            Text(temperature, format: .measurement(width: .abbreviated, usage: .asProvided))
        }
        .font(.title)
    }
}

struct Text_Measurement_Previews: PreviewProvider {
    static var previews: some View {
        Text_Measurement()
    }
}
