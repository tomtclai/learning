//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct TextField_OnSubmit: View {
    @State private var name = ""
    @State private var names = ["Donny", "Sean", "Paul"]
    
    var body: some View {
        VStack(spacing: 20.0) {
            HeaderView("TextField",
                       subtitle: "onSubmit",
                       desc: "You can determine what happens when the keyboard's return button is tapped.", back: .orange)
            
            TextField("Join the group!", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    names.append(name)
                    name = ""
                }
                .submitLabel(.join)
            
            List(names, id: \.self) { name in
                Text(name)
                    .padding()
            }
        }
        .font(.title)
    }
}

struct OnSubmit_Intro_Previews: PreviewProvider {
    static var previews: some View {
        TextField_OnSubmit()
    }
}
