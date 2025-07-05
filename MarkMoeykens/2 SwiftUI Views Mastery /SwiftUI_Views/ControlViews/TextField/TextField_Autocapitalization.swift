//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI
/* This was introduced in iOS 15. Prior to this, use .autocapitalization. */
struct TextField_Autocapitalization: View {
    @State private var textFieldData1 = ""
    @State private var textFieldData2 = ""
    @State private var textFieldData3 = ""
    @State private var textFieldData4 = ""
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Words")
            TextField("First & Last Name", text: $textFieldData1)
                .textInputAutocapitalization(.words)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Text("Sentences (default)")
            TextField("Bio", text: $textFieldData2)
                .textInputAutocapitalization(.sentences)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Text("Never")
            TextField("Web Address", text: $textFieldData3)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Text("Characters")
            TextField("Country Code", text: $textFieldData4)
                .textInputAutocapitalization(.characters)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
        }
    }
}

struct TextField_Autocapitalization_Previews: PreviewProvider {
    static var previews: some View {
        TextField_Autocapitalization()
    }
}
