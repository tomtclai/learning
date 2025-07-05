//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Text_DynamicTypeSize: View {
    var body: some View {
        VStack(spacing: 20.0) {
            HeaderView("Text",
                       subtitle: "DynamicTypeSize",
                       desc: "Set a range of type sizes your text can change within.",
                       back: .green,
                       textColor: .white)
            
            Text("My Header")
                .font(.largeTitle)
            
            Text("My Header Limited")
                .font(.largeTitle)
                .dynamicTypeSize(.large ... .xLarge)
        }
        .font(.title)
    }
}

struct Text_DynamicTypeSize_Previews: PreviewProvider {
    static var previews: some View {
        Text_DynamicTypeSize()
    }
}
