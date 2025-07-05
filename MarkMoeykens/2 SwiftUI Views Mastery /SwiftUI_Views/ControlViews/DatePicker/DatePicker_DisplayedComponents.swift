//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct DatePicker_DisplayedComponents: View {
    @State private var date = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("DatePicker",
                       subtitle: "Displayed Components",
                       desc: "You can show more than just a date. You can also show just the time or a combination of date and time.", back: .green)
            
            DatePicker("Today", selection: $date, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .padding(.horizontal)

            DatePicker("Today", selection: $date, displayedComponents: [.hourAndMinute, .date])
                .labelsHidden()
                .padding(.horizontal)
                .buttonStyle(.bordered)
        }
        .font(.title)
    }
}

struct DatePicker_DisplayedComponents_Previews: PreviewProvider {
    static var previews: some View {
        DatePicker_DisplayedComponents()
    }
}
