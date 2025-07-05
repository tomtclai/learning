//  Created by Mark Moeykens on 6/19/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Navigation_NavBarItems : View {
    var body: some View {
        NavigationStack {
            VStack {
            }
            .navigationTitle("Navigation Bar Buttons")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "bell.fill")
                            .padding(.horizontal)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Actions", action: { })
                }
            }
            .tint(.pink)
        }
    }
}

struct Navigation_NavBarItems_Previews : PreviewProvider {
    static var previews: some View {
        Navigation_NavBarItems()
    }
}
