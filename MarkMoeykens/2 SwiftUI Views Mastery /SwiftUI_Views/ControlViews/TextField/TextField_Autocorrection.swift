//  Created by Mark Moeykens on 11/17/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct TextField_Autocorrection: View {
    @State private var lastName = ""
    @State private var code = ""

    var body: some View {
        VStack(spacing: 10) {
            TextField("last name", text: $lastName)
                .autocorrectionDisabled(false) // Default: Offer suggestions (redundant)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            TextField("one time unique code", text: $code)
                .autocorrectionDisabled() // Don't offer suggestions
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
        }
        .font(.title)
    }
}

struct TextField_Autocorrection_Previews: PreviewProvider {
    static var previews: some View {
        TextField_Autocorrection()
    }
}
