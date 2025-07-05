// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct ViewThatFits_Intro: View {
    var body: some View {
        ViewThatFits(in: .horizontal) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.pink.opacity(0.7))
                .overlay(Text("For Landscape"))
                .frame(width: 700, height: 75)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.orange.opacity(0.7))
                .overlay(Text("For Portrait"))
                .frame(width: 350, height: 75)
            
            Text("No views fit")
        }
    }
}

struct ViewThatFits_Intro_Previews: PreviewProvider {
    static var previews: some View {
        ViewThatFits_Intro()
    }
}
