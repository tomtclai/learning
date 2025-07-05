//
//  Text_Styles.swift
//  100Views
//
//  Created by Mark Moeykens on 7/22/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.
//

import SwiftUI

struct Text_TextStyles: View {
    var body: some View {
        VStack(spacing: 10) {
            Image("Font")
            
            HeaderView("Text",
                       subtitle: "Text Styles",
                       desc: "You can add a TextStyle to the Text view by using the .font modifier.",
                       back: .green, textColor: .white)
                .font(.title)
            
            Group {
                Text("Font.largeTitle").font(.largeTitle)
                Text("Font.title").font(.title)
                Text("Font.title2 (iOS 14)").font(.title2)
                Text("Font.title3 (iOS 14)").font(.title3)
            }
            Group {
                Text("Font.headline").font(.headline)
                Text("Font.body").font(.body)
                Text("Font.callout").font(.callout)
                Text("Font.subheadline").font(.subheadline)
                Text("Font.footnote").font(.footnote)
                Text("Font.caption").font(.caption)
                Text("Font.caption2 (iOS 14)").font(.caption2)
            }
        }
    }
}

struct Text_TextStyles_Previews: PreviewProvider {
    static var previews: some View {
        Text_TextStyles()
    }
}
