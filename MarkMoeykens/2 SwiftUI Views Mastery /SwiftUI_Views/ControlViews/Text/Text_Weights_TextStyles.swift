//  Created by Mark Moeykens on 9/12/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.
//

import SwiftUI

struct Text_Weights_TextStyles: View {
    var body: some View {
        return VStack(spacing: 20) {
            HStack {
                Image("FontWeight")
                Image(systemName: "plus")
                Image("Font")
            }
            
            HeaderView("Text", subtitle: "Weight & Text Styles",
                       desc: "These weights can be combined with Text Styles.",
                       back: .green, textColor: .white)
                .font(.title)
            
            Text("Ultralight - Title")
                .fontWeight(.ultraLight)
                .font(.title)
            Text("Thin - Body")
                .fontWeight(.thin)
                .font(.body)
            Text("Light - Large Title")
                .fontWeight(.light)
                .font(.largeTitle)
            Text("Bold - Callout")
                .fontWeight(.bold)
                .font(.callout)
            Text("Black - Title")
                .font(Font.title.weight(.black))
        }
    }
}

struct Text_Weights_TextStyles_Previews: PreviewProvider {
    static var previews: some View {
        Text_Weights_TextStyles()
    }
}
