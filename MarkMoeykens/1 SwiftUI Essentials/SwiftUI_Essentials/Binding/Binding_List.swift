// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Binding_List: View {
    @State private var names = ["Mark", "Lem", "Rod"]
    
    var body: some View {
        NavigationStack {
            List($names, id: \.self) { $name in
                NavigationLink(name) {
                    EditNameSubview(name: $name)
                }
            }
            .font(.title)
            .navigationTitle("Names")
        }
    }
}

#Preview {
    Binding_List()
}
