// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct ScenePhase_Intro: View {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Savings")
                        .font(.largeTitle.weight(.thin))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.teal.opacity(0.4), in: Rectangle())
                    
                    LabeledContent("Balance") {
                        Text(3274.87, format: .currency(code: "usd"))
                    }
                    .padding()
                }
            }
            .font(.title)
            .navigationTitle("Bank Accounts")
            .blur(radius: scenePhase == .inactive ? 8 : 0)
        }
    }
}

struct ScenePhase_Intro_Previews: PreviewProvider {
    static var previews: some View {
        ScenePhase_Intro()
    }
}
