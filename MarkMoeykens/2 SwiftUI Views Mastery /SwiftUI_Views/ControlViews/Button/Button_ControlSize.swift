//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Button_ControlSize: View {
    var body: some View {
        VStack(spacing: 60.0) {
            Button("Bordered - Mini") { }
                .controlSize(.mini)
            
            Button("Bordered - Small") { }
                .controlSize(.small)
            
            Button("Bordered - Regular") { }
                .controlSize(.regular)
            
            Button("Bordered - Large") { }
                .controlSize(.large)
            
            Button(action: {}) {
                Text("Bordered - Large")
                    .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
        }
        .buttonStyle(.bordered)
        .tint(.purple)
        .font(.title)
    }
}

struct Button_ControlSize_Previews: PreviewProvider {
    static var previews: some View {
        Button_ControlSize()
    }
}
