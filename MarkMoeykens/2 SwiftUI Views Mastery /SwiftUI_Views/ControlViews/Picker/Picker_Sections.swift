// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Picker_Sections: View {
    @State private var favoriteState = 1
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Picker",
                       subtitle: "Sections",
                       desc: "Use sections within your picker values to organize selections.")
            
            Picker("States", selection: $favoriteState) {
                Section {
                    Text("California").tag(0)
                    Text("Utah").tag(1)
                } header: {
                    Text("West")
                }
                
                Section {
                    Text("Vermont").tag(2)
                    Text("New Hampshire").tag(3)
                } header: {
                    Text("East")
                }
            }
            
            Spacer()
        }
        .font(.title)
    }
}

struct Picker_Sections_Previews: PreviewProvider {
    static var previews: some View {
        Picker_Sections()
    }
}
