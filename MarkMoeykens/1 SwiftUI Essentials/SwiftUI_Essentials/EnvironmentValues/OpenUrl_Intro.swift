// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct OpenUrl_Intro: View {
    @Environment(\.openURL) var openURL
    
    @State private var selection = 0

    var body: some View {
        VStack {
            Link(destination: URL(string: "https://www.example.com")!) {
                Text("More Info")
            }
            .buttonStyle(.bordered)
            
            Picker(selection: $selection, label: Text("Select a country")) {
                Text("USA").tag(0)
                Text("Canada").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            
            Button {
                let url = selection == 0
                ? URL(string: "https://www.usa-example.com")!
                : URL(string: "https://www.canada-example.com")!

                openURL(url)
            } label: {
                Text("Customer Service")
            }
            .buttonStyle(.borderedProminent)
        }
        .font(.title)
    }
}

struct OpenUrl_Intro_Previews: PreviewProvider {
    static var previews: some View {
        OpenUrl_Intro()
    }
}
