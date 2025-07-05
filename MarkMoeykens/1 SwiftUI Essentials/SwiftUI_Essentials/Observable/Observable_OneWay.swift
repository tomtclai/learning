// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

@Observable // Solution
class PersonClass {
    var name = " "
    
    private var age = 0
}

struct Observable_OneWay: View {
    private var personClass = PersonClass()
    
    var body: some View {
        VStack {
            Button("Add Name") {
                personClass.name = "Natalie Miles"
            }
            .buttonStyle(.borderedProminent)
            
            GroupBox("Name") {
                Text(personClass.name)
            }
        }
        .font(.title)
    }
}

#Preview {
    Observable_OneWay()
}
