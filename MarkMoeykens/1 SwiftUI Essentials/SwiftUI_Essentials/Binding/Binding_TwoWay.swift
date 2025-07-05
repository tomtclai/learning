// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Binding_TwoWay: View {
    @State private var name = "Sean Ching"
    
    var body: some View {
        VStack(spacing: 20.0) {
            Text("Two-Way Binding")
                .font(.largeTitle.bold())
            
            Text(name)
            
            EditNameSubview(name: $name)
        }
        .font(.title)
        .padding()
    }
}

struct EditNameSubview: View {
    @Binding var name: String
    
    var body: some View {
        GroupBox("Subview") {
            TextField("name", text: $name)
                .textFieldStyle(.roundedBorder)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Binding_TwoWay()
}

#Preview("EditNameSubview", traits: .sizeThatFitsLayout) {
    @Previewable @State var name = "Mark Moeykens"
    EditNameSubview(name: $name)
}
