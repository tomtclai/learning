//
//  TextField_ContentType.swift
//  100Views
//
//  Created by Mark Moeykens on 6/29/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.
//

import SwiftUI

struct TextField_ContentType : View {
    @State private var textFieldData = ""

    // TODO: Include this in the book when we can get suggestions to show up in Simulator.
    var body: some View {
        VStack(spacing: 20) {
            Text("TextField")
                .font(.largeTitle)
            Text("Content Type")
                .font(.title)
                .foregroundStyle(.gray)
            Divider()
            TextField("City", text: $textFieldData)
                .textFieldStyle(.roundedBorder)
                .textContentType(.addressCity) // How to get city suggestions to show
                .padding(.horizontal)
        }
    }
}

struct TextField_ContentType_Previews : PreviewProvider {
    static var previews: some View {
        TextField_ContentType()
    }
}
