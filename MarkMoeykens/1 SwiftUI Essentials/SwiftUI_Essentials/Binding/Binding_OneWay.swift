// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Binding_OneWay: View {
    @State private var name = "Sean Ching"
    
    var body: some View {
        VStack(spacing: 20.0) {
            Text("One-Way Binding")
                .font(.largeTitle.bold())
            
            TextField("name", text: $name)
                .textFieldStyle(.roundedBorder)
            
            NameSubview(name: name)
        }
        .font(.title)
        .padding()
    }
}

struct NameSubview: View {
    var name: String
    
    var body: some View {
        GroupBox("Subview") {
            Text(name)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    Binding_OneWay()
}
