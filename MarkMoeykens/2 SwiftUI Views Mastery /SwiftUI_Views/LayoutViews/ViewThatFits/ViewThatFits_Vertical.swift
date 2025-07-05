// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct ViewThatFits_Vertical: View {
    var body: some View {
        ViewThatFits(in: .vertical) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.purple.opacity(0.7))
                .overlay(Text("For Portrait"))
                .frame(width: 200, height: 500)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.7))
                .overlay(Text("For Landscape"))
                .frame(width: 400, height: 100)
            
            Text("No views fit")
        }
    }
}

struct ViewThatFits_Vertical_Previews: PreviewProvider {
    static var previews: some View {
        ViewThatFits_Vertical()
    }
}
