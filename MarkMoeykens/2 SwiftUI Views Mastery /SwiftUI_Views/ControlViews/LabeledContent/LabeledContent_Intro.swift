// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct LabeledContent_Intro: View {
    var body: some View {
        VStack {
            VStack(spacing: 24.0) {
                LabeledContent("Label", value: "Value")
                
                LabeledContent("Label") {
                    Label("Value", systemImage: "camera.macro")
                }
                
                LabeledContent("Label", value: 55, format: .percent)
                
                LabeledContent {
                    Text("Value")
                        .font(.title.weight(.thin))
                } label: {
                    Text("Label")
                        .fontWeight(.bold)
                }
            }
            .padding()
            
            Form {
                LabeledContent("Number") {
                    Text(55, format: .number)
                }
                
                Text("Text with Badge")
                    .badge(55)
            }
        }
        .font(.title)
    }
}

struct LabeledContent_Intro_Previews: PreviewProvider {
    static var previews: some View {
        LabeledContent_Intro()
    }
}
