//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct DatePicker_Styles: View {
    @State private var date = Date()
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView("DatePicker",
                       subtitle: "Styles",
                       desc: "Graphical Style", back: .green)
            
            DatePicker("Birthday", selection: $date, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .frame(width: 320)
            
            DescView(desc: "Wheel Style", back: .green)
            DatePicker("Birthday", selection: $date, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
            
        }
        .font(.title)
        .ignoresSafeArea(edges: .bottom)
    }
}

struct DatePicker_Styles_Previews: PreviewProvider {
    static var previews: some View {
        DatePicker_Styles()
    }
}
