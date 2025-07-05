//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct NavLink_Intro: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                NavigationLink("Just Text", destination: SecondView())
                
                NavigationLink {
                    SecondView()
                } label: {
                    Label("Label", systemImage: "doc.text.fill")
                }
            }
            .navigationTitle("NavigationLink")
        }
        .font(.title)
    }
}

struct SecondView: View {
    var body: some View {
        VStack {
            Text("View 2")
                .font(.largeTitle)
        }
        .navigationTitle("Second View")
    }
}

struct NavLink_Intro_Previews: PreviewProvider {
    static var previews: some View {
        NavLink_Intro()
    }
}
