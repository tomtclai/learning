//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

@Observable
class UserOO {
    var userName = "scott.smith"
}

struct Environment_NotAvailableInInit: View {
    @Environment(UserOO.self) var user
    @State private var highlight = false
    
    init() {
        // Environment objects are not accessible in the init.
//        if user.userName == "scott.smith" {
//            highlight = true
//        }
    }
    
    var body: some View {
        Text(user.userName)
            .padding()
            .background(user.userName == "scott.smith" ? Color.yellow : Color.clear)
            .font(.title)
    }
}

#Preview {
    Environment_NotAvailableInInit()
        .environment(UserOO())
}
