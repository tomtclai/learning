//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct TextField_OnEditingChanged: View {
    @State private var text = ""
    @State private var isEditing = false
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("TextField",
                       subtitle: "onEditingChanged",
                       desc: "The onEditingChanged even tells you when the text field has the focus or not.",
                       back: .orange)
            
            Text("Turn border green when editing")
            TextField("10 characters", text: $text) { isEditing in
                self.isEditing = isEditing
            }
            .padding()
            .border(isEditing ? Color.green : Color.gray)
            .padding(.horizontal)
        }
        .font(.title)
    }
}

struct TextField_OnEditingChanged_Previews: PreviewProvider {
    static var previews: some View {
        TextField_OnEditingChanged()
    }
}
