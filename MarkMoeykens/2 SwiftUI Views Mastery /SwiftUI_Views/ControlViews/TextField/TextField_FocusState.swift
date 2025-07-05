//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct TextField_FocusState: View {
    @State private var name = ""
    @FocusState private var nameIsFocused: Bool

    var body: some View {
        VStack(spacing: 20.0) {
            HeaderView("TextField",
                       subtitle: "@FocusState",
                       desc: "Use @FocusState to set focus to a TextField.",
                       back: .orange)
            
            TextField("enter name to continue", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()
                .focused($nameIsFocused)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.red, lineWidth: nameIsFocused ? 1 : 0)
                            .padding())
            
            Button("Continue") {
                nameIsFocused = name.isEmpty
            }
        }
        .font(.title)
    }
}

struct TextField_FocusState_Previews: PreviewProvider {
    static var previews: some View {
        TextField_FocusState()
    }
}
