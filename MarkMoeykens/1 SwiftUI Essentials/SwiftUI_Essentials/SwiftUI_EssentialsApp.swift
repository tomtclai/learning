// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

@Observable
class UserModel {
    var username = "Ellen"
    var showAsOnline = true
}

@main
struct SwiftUI_EssentialsApp: App {
    var body: some Scene {
        WindowGroup {
            Conventions()
        }
    }
}
