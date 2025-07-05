//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct DisclosureGroup_Intro: View {
    @State private var disclosureExpanded = true
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("DisclosureGroup",
                       subtitle: "Introduction",
                       desc: "Use the DisclosureGroup when you want to expand or collapse other views.")
            
            VStack(spacing: 20) {
                DisclosureGroup("More Info") {
                    Text("Tap the row to expand/collapse the content of the DisclosureGroup. DisclosureGroups are collapsed by default.")
                }
                
                DisclosureGroup(
                    content: {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(.orange)
                        Text("You can use another initializer to customize your label too.")
                    },
                    label: {
                        Text("More Info")
                            .bold()
                    })
                
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .font(.title)
    }
}

struct DisclosureGroup_Intro_Previews: PreviewProvider {
    static var previews: some View {
        DisclosureGroup_Intro()
    }
}
