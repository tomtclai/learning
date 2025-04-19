//
//  EmailAddress.swift
//  ComposingViews
//
//  Created by Tom Lai on 4/19/25.
//

import SwiftUI

struct EmailAddress: View {
    let address: String
    var body: some View {
        HStack {
            Image(systemName: "envelope")
            Text(address)
        }
    }
}

#Preview {
    EmailAddress(address:"abc@cde.com")
}
