// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct TextField_PersonNameComponents: View {
    @State private var name = PersonNameComponents(givenName: "Matthew",
                                                   middleName: "Robert",
                                                   familyName: "Moeykens")
    
    var body: some View {
        VStack(spacing: 10) {
            HeaderView("TextField", subtitle: "PersonNameComponents",
                       desc: "Use the value and format initializer to use a TextField with nonstring types.",
                       back: .orange)
            
            TextField("Short Name", value: $name, format: .name(style: .short))
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            TextField("Medium Name", value: $name, format: .name(style: .medium))
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            TextField("Long Name", value: $name, format: .name(style: .long))
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
        }
        .font(.title)
    }
}

struct TextField_ValueFormat_Previews: PreviewProvider {
    static var previews: some View {
        TextField_PersonNameComponents()
    }
}
