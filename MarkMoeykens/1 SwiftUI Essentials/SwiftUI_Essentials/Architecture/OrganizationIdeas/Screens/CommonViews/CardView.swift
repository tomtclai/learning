// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct CardView<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        GroupBox {
            Text(title)
                .font(.title.weight(.bold).width(.compressed))
            Divider()
            
            VStack(content: content)
        }
    }
}

#Preview {
    CardView(title: "Preview Title") {
        Text("Here is some content")
        Text("Here is some MORE content")
    }
}
