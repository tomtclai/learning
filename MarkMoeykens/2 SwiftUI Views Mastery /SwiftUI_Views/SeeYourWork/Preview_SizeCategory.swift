//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Preview_SizeCategory: View {
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Previews",
                       subtitle: "Dynamic Type Variants",
                       desc: "For testing accessibility text size, use the 'Dynamic Type Variants' option.",
                       back: .red,
                       textColor: .white)
        }.font(.title)
    }
}

struct Preview_SizeCategory_Previews: PreviewProvider {
    static var previews: some View {
        Preview_SizeCategory()
    }
}
