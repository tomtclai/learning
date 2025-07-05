//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI
/*
Group just content.
 
 desc: "You can use the GroupBox to combine views that are related.",
 back: .blue, textColor: .white)
 */
struct GroupBox_Intro: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 40) {
            GroupBox {
                Text("Login")
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $username)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .padding(.horizontal)
        .font(.title)
    }
}

struct GroupBox_Intro_Previews: PreviewProvider {
    static var previews: some View {
        GroupBox_Intro()
            .preferredColorScheme(.dark)
    }
}
