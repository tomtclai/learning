// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Navigation_ToolbarBackground: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.opacity(0.25)
                    .ignoresSafeArea()
                
            }
            .navigationTitle("Toolbar Background")
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    Navigation_ToolbarBackground()
}
