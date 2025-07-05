// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct ProgressView_Tint: View {
    @State private var progress = 0.75
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("ProgressView",
                       subtitle: "Tint",
                       desc: "Starting in iOS 15, you can use the tint modifier to change the color of the progress views.")
            
            ProgressView(value: progress, label: {
                HStack {
                    Spacer()
                    Text("Progress (\(Int(progress * 100))%)")
                        .font(.title)
                        .foregroundStyle(.white)
                    Spacer()
                }
            })
            .tint(.mint)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16)
                            .fill(Color("GoldColor"))
                            .shadow(radius: 10, y: 16))
            .padding(.horizontal)
            
            Text("For the circular progress view, you need to set the color through the style modifier:")
                .padding(.horizontal)
            
            ProgressView()
                .tint(.red)
        }
        .font(.title)
    }
}

struct ProgressView_Tint_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView_Tint()
    }
}
