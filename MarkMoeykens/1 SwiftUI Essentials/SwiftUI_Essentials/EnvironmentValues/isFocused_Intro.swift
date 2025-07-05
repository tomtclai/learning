// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct isFocused_Intro: View {
    @Environment(\.isFocused) var isFormFocused
    @FocusState private var isFocused: Bool
    @State private var firstName = ""
    @State private var lastName = ""

    var body: some View {
        Form {
            Section {
                TextField("first name", text: $firstName)
                    .focused($isFocused)
                    .background(isFocused ? Color.yellow : Color.clear)
                    .border(isFocused ? Color.green : Color.clear)
                
                TextField("last name", text: $lastName)
                    .background(isFocused ? Color.yellow : Color.clear)
            }
            .background(Color.red.opacity(0.5), in: RoundedRectangle(cornerRadius: 8))
        }
        .font(.title)
    }
}

struct isFocused_Intro_Previews: PreviewProvider {
    static var previews: some View {
        isFocused_Intro()
    }
}
