//  Created by Mark Moeykens on 6/18/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Form_WithControls : View {
    @State private var isOn = true
    @State private var textFieldData = "This is a text field"
    
    var body: some View {
        Form {
            Section {
                Text("This will give you an idea of how different controls are rendered in a Form.")
                    .foregroundStyle(.white)
                    .listRowBackground(Color.purple)
            } header: {
                Text("Controls in a form")
                    .font(.title)
                    .foregroundStyle(Color.gray)
            }
            Section {
                Button(action: {}) { Text("Button") }
                Toggle(isOn: $isOn) { Text("Toggle") }
                Stepper(onIncrement: {}, onDecrement: {}) { Text("Stepper") }
                TextField("", text: $textFieldData)
                    .textFieldStyle(.roundedBorder)
                Image(systemName: "leaf.arrow.circlepath").font(.title)
                Circle()
                    .frame(height: 30)
            }
        }
        .font(.title)
    }
}

struct Form_WithControls_Previews : PreviewProvider {
    static var previews: some View {
        Form_WithControls()
    }
}
