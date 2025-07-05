// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
/*
 Can use as background color
 */
struct CRF_IgnoresSafeAreaEdges: View {
    var body: some View {
        VStack {
            Text("VStack Top")
            
            Spacer()
            
            Text("VStack Bottom")
        }
        .font(.title)
        .border(Color.red)
        .containerRelativeFrame([.horizontal, .vertical])
        .background(Gradient(colors: [.teal, .cyan, .green]).opacity(0.6))
    }
}

#Preview {
    CRF_IgnoresSafeAreaEdges()
}
