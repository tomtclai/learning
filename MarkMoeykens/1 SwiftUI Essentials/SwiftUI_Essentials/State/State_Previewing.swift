//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct State_Previewing: View {
    // The @State properties would have to be public (not private)
    @State var featureOne: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("State",
                       subtitle: "Previewing",
                       desc: "You can pass in variables in your Preview to test with different values.", back: .blue, textColor: .white)
            
            Toggle("Feature One", isOn: $featureOne)
                .padding(.horizontal)
        }
        .font(.title)
    }
}

#Preview("Feature off", traits: .sizeThatFitsLayout) {
    State_Previewing(featureOne: false)
}

#Preview("Feature on", traits: .sizeThatFitsLayout) {
    State_Previewing(featureOne: true)
}
