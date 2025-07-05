// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
/*
 iOS 16.4
 */
struct Scrollview_ScrollBounceBehavior: View {
    var body: some View {
        VStack(spacing: 24.0) {
            GroupBox {
                ScrollView {
                    Text("The ScrollView will bounce by default")
                }
                .frame(maxWidth: .infinity)
            }
            
            GroupBox {
                ScrollView {
                    Text("This ScrollView will only bounce when contents exceed bounds")
                }
                .frame(maxWidth: .infinity)
                .scrollBounceBehavior(.basedOnSize)
            }
        }
        .padding()
        .font(.title)
    }
}

#Preview {
    Scrollview_ScrollBounceBehavior()
}
