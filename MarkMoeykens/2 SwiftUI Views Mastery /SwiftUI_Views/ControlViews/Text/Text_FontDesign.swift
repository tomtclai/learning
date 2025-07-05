//
//  Text_FontDesign.swift
//  100Views
//
//  Created by Mark Moeykens on 6/28/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.
//

import SwiftUI
/*
HeaderView("Text", subtitle: "Font Design", desc: "There are 4 font designs now in iOS. Use Font.system to set the font design you want.", back: .green, textColor: .white)
*/
struct Text_FontDesign : View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Default font design")
                .font(Font.system(size: 30, design: Font.Design.default))
            
            // You can remove the "Font.Design" of the enum
            Text("Here is monospaced")
                .font(.system(size: 30, design: .monospaced))
            
            Text("And there is rounded")
                .font(.system(.title, design: .rounded))
            
            Text("Finally, we have serif!")
                .font(.system(.title, design: .serif))
            
            DescView(desc: "A \"serif\" is a little piece that comes off the letter.", back: .green, textColor: .white)
            
            Image("Serif")
            
            Divider()
            
            // iOS 16
            Text("Using Font Design Modifier")
                .fontDesign(.rounded)
                .fontWeight(.heavy)
        }
        .font(.title)
    }
}

struct Text_FontDesign_Previews : PreviewProvider {
    static var previews: some View {
        Text_FontDesign()
    }
}
