// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct TextField_FocusState_WithEnum: View {
    enum NameFields {
        case firstName
        case lastName
    }
    
    @State private var firstName = ""
    @State private var lastName = ""
    @FocusState private var nameFields: NameFields?

    var body: some View {
        VStack(spacing: 20.0) {
            HeaderView("TextField", subtitle: "@FocusState",
                       desc: "Use an enum when focus can be set to multiple text fields on the screen.", back: .orange)
            
            TextField("First name", text: $firstName)
                .padding(.horizontal)
                .focused($nameFields, equals: .firstName)
            TextField("Last name", text: $lastName)
                .padding(.horizontal)
                .focused($nameFields, equals: .lastName)
            
            Button("Save") {
                if firstName.isEmpty {
                    nameFields = .firstName
                } else if lastName.isEmpty {
                    nameFields = .lastName
                } else {
                    // Save function
                }
            }
        }
        .textFieldStyle(.roundedBorder)
        .font(.title)
    }
}

struct TextField_FocusState_WithEnum_Previews: PreviewProvider {
    static var previews: some View {
        TextField_FocusState_WithEnum()
    }
}
