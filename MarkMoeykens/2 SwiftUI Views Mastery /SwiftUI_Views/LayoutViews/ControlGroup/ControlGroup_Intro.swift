//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct ControlGroup_Intro: View {
    var body: some View {
        VStack(spacing: 20.0) {
            HeaderView("ControlGroup",
                       subtitle: "Introduction",
                       desc: "Use a ControlGroup view to group up related controls.")
            
            ControlGroup {
                Button("Hello!") { }
                Button(action: {}) {
                    Image(systemName: "gearshape.fill")
                }
            }

            DescView(desc: "You can change the default style to 'navigation':")
            ControlGroup {
                Button("Hello!") { }
                Button(action: {}) {
                    Image(systemName: "gearshape.fill")
                }
            }
            .controlGroupStyle(.navigation)
        }
        .font(.title)
    }
}

struct ControlGroup_Intro_Previews: PreviewProvider {
    static var previews: some View {
        ControlGroup_Intro()
    }
}
