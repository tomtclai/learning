//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct DatePicker_Customizing: View {
    @State private var date = Date()
    
    var body: some View {
        VStack(spacing: 30) {
            HeaderView("DatePicker",
                       subtitle: "Customizing",
                       desc: "Customize the background and accent color:", back: .green)
            
            DatePicker("Birthday", selection: $date, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .accentColor(.green) // Deprecated but tint does not work.
                .padding()
                .background(RoundedRectangle(cornerRadius: 20)
                                .fill(Color.green)
                                .opacity(0.1)
                                .shadow(radius: 1, x: 4, y: 4))
                .padding(.horizontal)
            
            DatePicker("Today", selection: $date, displayedComponents: .date)
                .frame(height: 50)
                .padding()
                .background(Rectangle()
                                .fill(Color.green)
                                .shadow(radius: 4)
                                .opacity(0.2))
        }.font(.title)
    }
}

struct DatePicker_Customizing_Previews: PreviewProvider {
    static var previews: some View {
        DatePicker_Customizing()
    }
}
