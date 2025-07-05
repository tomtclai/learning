// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

@Observable
class AddressOO {
    var state = "Vermont"
}

struct Environment_ReadOnly: View {
    @Environment(AddressOO.self) private var addressOO
    
    var body: some View {
        Form {
            Section("One-Way Binding") {
                Text("State: \(addressOO.state)")
                    .bold()
            }
            
            Section("Two-Way Binding") {
//                TextField("Enter State", text: $addressOO.state)
            }
        }
        .headerProminence(.increased)
    }
}


#Preview {
    Environment_ReadOnly()
        .environment(AddressOO())
}
