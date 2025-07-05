// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct NavLink_WithDifferentTypes: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16.0) {
                NavigationLink(value: "NavigationLink 1") {
                    Text("Navigate with String")
                }
                NavigationLink(value: true) {
                    Text("Navigate with Bool")
                }
            }
            .navigationDestination(for: String.self) { stringValue in
                Text("Value is: ") + Text("\(stringValue)").bold()
            }
            .navigationDestination(for: Bool.self) { boolValue in
                Text("Value is: ") + Text("\(boolValue.description)").bold()
            }
            .navigationTitle("Navigation Destination")
        }
        .font(.title)
    }
}

struct NavLink_WithDifferentTypes_Previews: PreviewProvider {
    static var previews: some View {
        NavLink_WithDifferentTypes()
    }
}
