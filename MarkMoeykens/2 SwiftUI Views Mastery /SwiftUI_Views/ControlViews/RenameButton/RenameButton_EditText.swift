// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct RenameButton_EditText: View {
    @State private var editText = false
    @State private var name = "Mark"
    @FocusState private var nameFocused: Bool
    
    var body: some View {
        VStack {
            if editText {
                HStack {
                    TextField("name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .focused($nameFocused)
                    Button("Done") {
                        editText.toggle()
                    }
                }
            } else {
                HStack {
                    Text(name)
                    Spacer()
                    RenameButton()
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .renameAction {
            editText.toggle()
            nameFocused.toggle()
        }
        .padding()
    }
}

struct RenameButton_EditText_Previews: PreviewProvider {
    static var previews: some View {
        RenameButton_EditText()
    }
}
