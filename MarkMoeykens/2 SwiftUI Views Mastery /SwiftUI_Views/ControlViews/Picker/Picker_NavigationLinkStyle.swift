// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Picker_NavigationLinkStyle: View {
    @State private var selectedDev = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("iOS Dev", selection: $selectedDev) {
                    Text("Lem").tag(0)
                    Text("Mark").tag(1)
                    Text("Rod").tag(2)
                }
                .pickerStyle(.navigationLink)
            }
            .font(.title)
        }
    }
}

#Preview {
    Picker_NavigationLinkStyle()
}
