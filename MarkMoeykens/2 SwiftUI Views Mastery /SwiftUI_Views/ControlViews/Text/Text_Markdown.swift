//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Text_Markdown: View {
    var body: some View {
        VStack(spacing: 20.0) {
            HeaderView("Text",
                       subtitle: "Markdown",
                       desc: "You can include Markdown formatting inside of your Text views.",
                       back: .green, textColor: .white)
            Text("*Italic*")
            Text("_Italic_")
            Text("**Bold**")
            Text("__Bold__")
            Text("***Bold & Italic***")
            Text("___Bold & Italic___")
            Text("[URL](https://www.bigmountainstudio.com)")
            Text("`Code // Monospaced`")
        }
        .font(.title)
    }
}

struct Text_Markdown_Previews: PreviewProvider {
    static var previews: some View {
        Text_Markdown()
    }
}
