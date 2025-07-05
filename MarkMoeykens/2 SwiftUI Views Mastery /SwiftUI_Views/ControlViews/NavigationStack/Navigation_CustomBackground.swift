// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Navigation_CustomBackground: View {
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                    .background(
                        LinearGradient(colors: [.green, .blue],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                        .opacity(0.5)
                        .shadow(.drop(radius: 2, y: 2)),
                        ignoresSafeAreaEdges: .top)
                
                Spacer()
                /*
                Text("The background modifier that allows you to set Style will ignore safe area edges by default.")
                 BOOK NOTE: This will only work on ONE Navigation Stack.
                 */
            }
            .navigationTitle("Custom Background")
        }
    }
}

struct Navigation_CustomBackground_Previews: PreviewProvider {
    static var previews: some View {
        Navigation_CustomBackground()
    }
}
