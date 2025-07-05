//
//  Text_2_0_Shrinking.swift
//  100Views
//
//  Created by Mark Moeykens on 6/9/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.
//

import SwiftUI

struct Text_MinimumScaleFactor : View {
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Text",
                       subtitle: "Minimum Scale Factor",
                       desc: "You can shrink text to a minimum percentage of its original font size with this modifier.",
                       back: .green, textColor: .white)
            
            Group {
                Text("This text is set to a minimum scale factor of 0.6.")
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                Text("This text is set to a minimum scale factor of 0.7.")
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text("This text is set to a minimum scale factor of 0.8.")
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text("This text is set to a minimum scale factor of 0.9.")
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
            }
            .truncationMode(.middle)
            .padding(.horizontal)
        }
        .font(.title)
    }
}

struct Text_MinimumScaleFactor_Previews : PreviewProvider {
    static var previews: some View {
        Text_MinimumScaleFactor()
    }
}
