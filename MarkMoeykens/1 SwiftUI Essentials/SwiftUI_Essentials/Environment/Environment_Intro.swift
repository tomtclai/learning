// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

// You're using a class that conforms to Observable so you can bind to properties within it
@Observable
class DeveloperOO {
    var name: String = "Awesome developer"
}

struct Environment_Intro: View {
    var body: some View {
        NavigationStack {
            NavigationLink("View Developer") {
                DeveloperView()
            }
            .navigationTitle("Developer")
        }
        .environment(DeveloperOO())
        .font(.title)
    }
}

struct DeveloperView: View {
    @Environment(DeveloperOO.self) private var dev
    
    var body: some View {
        Text("Hello, \(dev.name)!")
            .navigationTitle("Developer View")
    }
}

#Preview {
    Environment_Intro()
}

#Preview("Child View") {
    DeveloperView()
        .environment(DeveloperOO())
        .font(.title)
}
