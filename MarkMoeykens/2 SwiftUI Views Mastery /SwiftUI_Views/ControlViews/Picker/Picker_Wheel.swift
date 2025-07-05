// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Picker_Wheel: View {
    @State private var yourName = "Mark"
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Picker",
                       subtitle: "Wheel Style",
                       desc: "You can change the way a Picker looks by using the pickerStyle modifier.")

            Picker("Name", selection: $yourName) {
                Text("Paul").tag("Paul")
                Text("Chris").tag("Chris")
                Text("Mark").tag("Mark")
                Text("Scott").tag("Scott")
                Text("Meng").tag("Meng")
            }
            .pickerStyle(.wheel)
        }
        .font(.title)
    }
}

struct Picker_Wheel_Previews: PreviewProvider {
    static var previews: some View {
        Picker_Wheel()
    }
}
