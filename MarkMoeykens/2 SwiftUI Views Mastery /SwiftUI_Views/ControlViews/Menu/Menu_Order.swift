// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Menu_Order: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            HStack(spacing: 32) {
                Menu("Priority") {
                    Button("Menu Item 1", action: {})
                    Button("Menu Item 2", action: {})
                    Button("Menu Item 3", action: {})
                    Button("Menu Item 4", action: {})
                    Button("Menu Item 5", action: {})
                }
                .menuOrder(.priority) /* Default */

                Menu("Fixed Order") {
                    Button("Menu Item 1", action: {})
                    Button("Menu Item 2", action: {})
                    Button("Menu Item 3", action: {})
                    Button("Menu Item 4", action: {})
                    Button("Menu Item 5", action: {})
                }
                .menuOrder(.fixed)
            }
        }
        .font(.title)
    }
}

struct Menu_Order_Previews: PreviewProvider {
    static var previews: some View {
        Menu_Order()
    }
}
