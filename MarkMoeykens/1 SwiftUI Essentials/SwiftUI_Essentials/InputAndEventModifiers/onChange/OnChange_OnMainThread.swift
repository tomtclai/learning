// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
/*
 BOOK NOTE:
 As of Xcode 14 beta, this doesn't seem to work when running in Preview.
 Run this example in the Simulator to see it work.
 */
struct OnChange_OnMainThread: View {
    @State private var input = ""
    @State private var validationColor = Color.red
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("onChange", subtitle: "On Main Thread",
                       desc: "It is important to note that the onChange code runs on the main thread. So use it to affect the UI but do not run long processes that could lock up the UI.",
                       back: .blue, textColor: .white)
            
            TextField("PIN (4 characters)", text: $input)
                .textFieldStyle(.roundedBorder)
                .overlay(validationColor,
                         in: RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 2))
                .padding()
        }
        .onChange(of: input) { _, newValue in
            //SendToServerToValidate() <- Don't do this
            
            validationColor = Color.red
            
            if newValue.count == 4 {
                validationColor = Color.green
            }
        }
        .font(.title)
    }
}

struct OnChange_OnMainThread_Previews: PreviewProvider {
    static var previews: some View {
        OnChange_OnMainThread()
    }
}
