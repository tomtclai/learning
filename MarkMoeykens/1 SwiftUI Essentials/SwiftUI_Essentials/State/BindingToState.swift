//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct BindingToState: View {
    @State var name = "Mariana"
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("State", subtitle: "Struct Variables", desc: "Add @State before the variable to make it mutable.", back: .blue, textColor: .white)
            
            Button(action: {
                name = "Mark" // name is now mutable
            }) {
                Text("Change Name to 'Mark'")
                    .padding()
                    .background(Color.blue, in: Capsule().stroke(lineWidth: 2))
            }
            Spacer()
            
            Text("Name:")
            Text("\(name)")
                .font(.largeTitle)
                .fontWeight(.black)
            
            Spacer()
        }
        .font(.title)
    }
}

#Preview {
    BindingToState(name: "Joe")
}
