//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Toggle_ToggleStyle: View {
    @State private var isOn = false
    @State private var toggleOn = true

    var body: some View {
        VStack(spacing: 20.0) {
            HeaderView("Toggle",
                       subtitle: "ToggleStyle",
                       desc: "Apply the toggleStyle to your Toggle to make it look like a button with two states.")
            
            Toggle(isOn: $isOn) {
                Image(systemName: "heart")
                    .symbolVariant(isOn ? .fill : .none)
            }.padding()
            
            Toggle(isOn: $isOn) {
                Image(systemName: "heart")
                    .symbolVariant(isOn ? .fill : .none)
            }
            .toggleStyle(.button)
            
            Toggle(isOn: $toggleOn) {
                Image(systemName: "heart")
                    .symbolVariant(toggleOn ? .fill : .none)
            }
            .toggleStyle(.button)
            
            
            
        Toggle(isOn: $toggleOn) {
            Image(systemName: "heart")
                .foregroundStyle(.blue) // Just symbol is blue
                .symbolVariant(toggleOn ? .fill : .none)
        }
        .toggleStyle(.button)
        .tint(.clear) // So the whole button is not blue
            
            
        }
        .font(.title)
    }
}

struct Toggle_ToggleStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle_ToggleStyle()
    }
}
