//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Button_Role: View {
    var body: some View {
        VStack(spacing: 100.0) {
            Button("Normal") { }
            
            Button("Destructive", role: .destructive) { }
            
            Button("Destructive", role: .destructive) { }
                .buttonStyle(.borderedProminent)
            
            Button("Cancel", role: .cancel) { }
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .font(.title)
    }
}

struct Button_Role_Previews: PreviewProvider {
    static var previews: some View {
        Button_Role()
    }
}
