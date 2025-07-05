//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct DatePicker_Intro: View {
    @State private var date = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("DatePicker",
                       subtitle: "Introduction",
                       desc: "The DatePicker will just show a date that can be tapped on like a button. You can add an optional label to it.", back: .green)
            
            Text("Default style pulls in:")
            
            DatePicker("Today", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .padding(.horizontal)
            
            Text("With label:")
            
            DatePicker("Today", selection: $date, displayedComponents: .date)
                .padding(.horizontal)
            
        }.font(.title)
    }
}

struct DatePicker_Intro_Previews: PreviewProvider {
    static var previews: some View {
        DatePicker_Intro()
    }
}
