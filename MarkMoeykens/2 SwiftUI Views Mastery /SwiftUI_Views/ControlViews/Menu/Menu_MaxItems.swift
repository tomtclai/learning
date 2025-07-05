//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Menu_MaxItems: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Menu {
                    Button("Menu Item 1", action: {})
                    Button("Menu Item 2", action: {})
                    Button("Menu Item 3", action: {})
                    Button("Menu Item 4", action: {})
                    Button("Menu Item 5", action: {})
                    Button("Menu Item 6", action: {})
                    Button("Menu Item 7", action: {})
                    Button("Menu Item 8", action: {})
                    Button("Menu Item 9", action: {})
                    Button("Menu Item 10", action: {})
                    Button("Menu Item 11", action: {})
                    Button("Menu Item 12", action: {})
                    Button("Menu Item 13", action: {})
                    Button("Menu Item 14", action: {})
                    Button("Menu Item 15", action: {})
                    Button("Menu Item 16", action: {})
                    Button("Menu Item 17", action: {})
                    Button("Menu Item 18", action: {})
                    Button("Menu Item 19", action: {})
                    Button("Menu Item 20", action: {})
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .padding(.leading, 20)
                }
                Spacer()
            }
            
            Spacer()
        }
        .font(.title)
    }
}

struct Menu_MaxItems_Previews: PreviewProvider {
    static var previews: some View {
        Menu_MaxItems()
    }
}
