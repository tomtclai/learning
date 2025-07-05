// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Form_HeaderProminence: View {
    var body: some View {
        Form {
            Section {
                Text("You have seen that you can customize the section header style. You can also use header prominence to style the header.")
            } header: {
                Text("Standard Header Prominence")
            }
            .headerProminence(.standard)
            
            Section {
                Text("Use increased header prominence to make it stand out more.")
            } header: {
                Text("Increased Header Prominence")
            }
            .headerProminence(.increased)
        }
    }
}

struct Form_HeaderProminence_Previews: PreviewProvider {
    static var previews: some View {
        Form_HeaderProminence()
    }
}
