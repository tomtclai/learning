// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct TextField_DismissKeyboard: View {
    @State private var name = ""
    @FocusState private var nameIsFocused: Bool

    var body: some View {
        VStack(spacing: 20.0) {
            HeaderView("TextField",
                       subtitle: "Dismiss Keyboard",
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button {
                    nameIsFocused = false
                } label: {
                    Text("Done")
                }

            }
        }
    }
}

struct TextField_DismissKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        TextField_DismissKeyboard()
    }
}
