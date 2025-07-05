//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Text_TextSelection: View {
    var body: some View {
        VStack(spacing: 60.0) {
            HeaderView("Text",
                       subtitle: "TextSelection",
                       desc: "Add the textSelection modifier to enable users to long-press and copy text.",
                       back: .green, textColor: .white)
            
            Text("No Text Selection")
            
            Text("Text Selection Enabled")
                .textSelection(.enabled)
        }
        .font(.title)
    }
}

struct Text_TextSelection_Previews: PreviewProvider {
    static var previews: some View {
        Text_TextSelection()
    }
}
