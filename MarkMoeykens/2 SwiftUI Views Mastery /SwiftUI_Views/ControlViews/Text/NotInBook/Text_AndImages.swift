//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Text_AndImages: View {
    var body: some View {
        VStack(spacing: 40) {
            HeaderView("Text",
                       subtitle: "Wrapping Images",
                       desc: "SwiftUI does not have anything that allows you to wrap views except for concatenated Text views.",
                       back: .green, textColor: .white)
            Text(Image(systemName: "calendar")) +
                Text("Jan 23   ") +
                Text(Image(systemName: "chart.pie.fill")) +
                Text("85%   ") +
                Text(Image(systemName: "message.fill")) +
                Text("8   ") +
                Text(Image(systemName: "paperclip")) +
                Text("2   ") +
                Text(Image(systemName: "switch.2")) +
                Text("39")
        }
    }
}

struct Text_AndImages_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Text_AndImages()
                .environment(\.sizeCategory, .extraExtraLarge)
                .previewLayout(.sizeThatFits)
            Text_AndImages()
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
                .previewLayout(.sizeThatFits)
        }
    }
}
