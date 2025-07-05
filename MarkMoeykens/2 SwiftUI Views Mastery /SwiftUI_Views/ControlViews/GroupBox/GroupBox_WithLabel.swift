//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI
/*
 HeaderView("GroupBox",
 subtitle: "With Label",
 desc: "Instead of using your own text label, the GroupBox has one built in.",
 back: .blue, textColor: .white)
 
 
 
 DescView(desc: "You can override the default label formatting.",
 back: .blue, textColor: .white)
 */
struct GroupBox_WithLabel: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 36) {
            GroupBox("Login (Default text format)") {
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $username)
                    .textFieldStyle(.roundedBorder)
            }
            
            GroupBox {
                TextField("New Password", text: $username)
                    .textFieldStyle(.roundedBorder)
                SecureField("New Password", text: $username)
                    .textFieldStyle(.roundedBorder)
            } label: {
                Text("Reset Password")
                    .font(.largeTitle.width(.compressed).weight(.heavy))
                    .frame(maxWidth: .infinity)
            }
        }
        .font(.title)
        .padding()
    }
}

struct GroupBox_WithLabel_Previews: PreviewProvider {
    static var previews: some View {
        GroupBox_WithLabel()
            .preferredColorScheme(.dark)
    }
}
