//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct TextField_OnChange: View {
    @State private var text = ""

    var body: some View {
        VStack(spacing: 20) {
            HeaderView("TextField",
                       subtitle: "onChange",
                       desc: "You can also use the onChange modifier to listen to changes and react to it. This is how you might use it to limit a user's text input.",
                       back: .orange)
            
            Text("Limit to 10")
            TextField("10 characters", text: $text)
                .onChange(of: text) { _, newValue in
                    text = String(newValue.prefix(10))
                }
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
        }
        .font(.title)
    }
}

struct TextField_OnChange_Previews: PreviewProvider {
    static var previews: some View {
        TextField_OnChange()
    }
}
