// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
/*
 iOS 15
 - Only works with attributed strings
 - Format: ^[/*the string*/](inflect: true)
 
 */
struct Text_Inflection: View {
    @State private var count = 1
    
    var body: some View {
        Form {
            Stepper("Count", value: $count, step: 1)
                .bold()
            Text("^[\(count) Year](inflect: true)")
            Text("^[\(count) Child](inflect: true)")
            Text("^[\(count) Man](inflect: true)")
            Text("^[\(count) Woman](inflect: true)")
            Text("^[\(count) Person](inflect: true)")
            Text("^[\(count) Moose](inflect: true)")
        }
        .font(.title)
    }
}

#Preview {
    Text_Inflection()
}
