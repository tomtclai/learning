// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Picker_ProgrammaticSelection: View {
    @State private var favoriteState = 1
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Picker",
                       subtitle: "Programmatic Selection",
                       desc: "You can programmatically change the Picker selection just by changing the bound property.")
            
            Picker("States", selection: $favoriteState) {
                Text("California").tag(0)
                Text("Colorado").tag(1)
                Text("Montana").tag(2)
                Text("Utah").tag(3)
                Text("Vermont").tag(4)
            }
            .pickerStyle(.wheel)
            .padding(.horizontal)
            
            Button("Select Vermont") {
                withAnimation {
                    favoriteState = 4
                }
            }
        }
        .font(.title)
    }
}

struct Picker_ProgrammaticSelection_Previews: PreviewProvider {
    static var previews: some View {
        Picker_ProgrammaticSelection()
            .preferredColorScheme(.dark)
    }
}
