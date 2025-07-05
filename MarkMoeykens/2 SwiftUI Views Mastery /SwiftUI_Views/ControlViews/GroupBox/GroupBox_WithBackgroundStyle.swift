// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
// iOS 16
struct GroupBox_WithBackgroundStyle: View {
    var body: some View {
        VStack(spacing: 45.0) {
            GroupBox(label: Label("Profile", systemImage: "person.circle")) {
                Text("Big Mountain Studio")
                
                Link("Learn More", destination: URL(string: "bigmountainstudio.com")!)
                    .buttonStyle(.borderedProminent)
                    .font(.title2)
            }
            .backgroundStyle(.thinMaterial)
            
            GroupBox {
                Text("Big Mountain Studio")
            } label: {
                Label("Profile", systemImage: "person.circle")
            }
            .foregroundStyle(.white)
            .backgroundStyle(.secondary)
        }
        .background(Image(.ballOfFire))
        .font(.title)
        .padding()
    }
}

#Preview {
    GroupBox_WithBackgroundStyle()
}
