//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct DisclosureGroup_Animated: View {
    @State private var disclosureExpanded = true
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("DisclosureGroup",
                       subtitle: "Experiment",
                       desc: "This is experimenting with 'flipping' the content up when disclosed.",
                       back: .orange)
            
            DisclosureGroup("Accent Color", isExpanded: $disclosureExpanded) {
                Text("Animate the expanding of the content.")
                    .font(.title2)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.orange.opacity(0.1)))
                    .rotation3DEffect(
                        .degrees(disclosureExpanded ? 0 : 60),
                        axis: (x: 1, y: 0, z: 0),
                        anchor: .top,
                        anchorZ: 0.0,
                        perspective: 1.0
                    )
                    .animation(Animation.easeInOut(duration: 0.35), value: disclosureExpanded)
                    .padding(.horizontal, 50)
            }
            .animation(Animation.easeInOut(duration: 1), value: disclosureExpanded)
            .tint(.orange)
            .padding()
            
            
            Spacer()
        }
        .font(.title)
    }
}

struct DisclosureGroup_Animated_Previews: PreviewProvider {
    static var previews: some View {
        DisclosureGroup_Animated()
    }
}
