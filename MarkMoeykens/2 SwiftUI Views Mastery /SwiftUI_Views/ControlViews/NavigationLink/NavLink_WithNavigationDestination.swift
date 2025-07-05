// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct NavLink_WithNavigationDestination: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(value: "NavigationLink 1") {
                    Text("Navigate 1")
                }
            }
            .navigationDestination(for: String.self) { stringValue in
                Text("Value is: ") + Text("\(stringValue)").bold()
            }
            .navigationTitle("Navigation Destination")
        }
        .font(.title)
    }
}

struct NavLink_WithNavigationDestination_Previews: PreviewProvider {
    static var previews: some View {
        NavLink_WithNavigationDestination()
    }
}
