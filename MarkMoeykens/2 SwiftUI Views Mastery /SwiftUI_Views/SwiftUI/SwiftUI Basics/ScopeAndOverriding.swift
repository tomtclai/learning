//  Created by Mark Moeykens on 9/28/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct ScopeAndOverriding: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Refactoring")
                .font(.largeTitle) // Overrides .font(.title)
            
            Text("Reusing Modifiers")
                .font(.title)
                .foregroundStyle(Color.gray)
            
            Text("You can put common modifiers on the parent views to be applied to all the child views.")
                .font(.title)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.white)
                .padding()
                .background(Color.blue)
        }
        .font(.title) // Apply font style to ALL Text views inside the VStack.
    }
}

#Preview {
    ScopeAndOverriding()
}
