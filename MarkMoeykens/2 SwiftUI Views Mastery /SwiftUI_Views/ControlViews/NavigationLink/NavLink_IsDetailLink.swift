//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct NavLink_IsDetailLink: View {
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 20) {
                NavigationLink("Navigate There ->") {
                    NavigationDestinationView()
                }
                
                NavigationLink("Navigate Here") {
                    NavigationDestinationView()
                }
                .isDetailLink(false) // Do not navigate to detail column
            }
            .navigationTitle("NavigationLink")
        } detail: {
            Text("Detail")
        }
        .font(.title)
    }
}

struct NavigationDestinationView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Navigation Destination")
        }
        .navigationTitle("Destination")
        .font(.title)
    }
}

struct NavLink_IsDetailLink_Previews: PreviewProvider {
    static var previews: some View {
        NavLink_IsDetailLink()
    }
}
