//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct DatePicker_InForm: View {
    @State private var date = Date()

    var body: some View {
        VStack(spacing: 20) {
            HeaderView("DatePicker",
                       subtitle: "Used in a Form",
                       desc: "When used in a form, the date picker uses the compact styling by default.",
                       back: .green)
            
            Form {
                DatePicker("Today", selection: $date,
                           displayedComponents: .date)
                
                Section {
                    Text("Graphical Picker Style:")
                    DatePicker("Birthday", selection: $date,
                               displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }
            }
        }
        .font(.title)
    }
}

struct DatePicker_InForm_Previews: PreviewProvider {
    static var previews: some View {
        DatePicker_InForm()
    }
}
