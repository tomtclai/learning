// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio
/*
 Note: On iOS you're only going to see the first column and NO header name. It's better to use and different container when targeting iOS.
 */
import SwiftUI

struct ColorInfo: Identifiable {
    let id = UUID()
    var name = ""
    var desc = Color.clear
}

struct Table_Intro: View {
    @State private var colors = [
        ColorInfo(name: "Red", desc: Color.red),
        ColorInfo(name: "Blue", desc: Color.blue),
        ColorInfo(name: "Purple", desc: Color.purple)
    ]

    var body: some View {
        Table(colors) {
            TableColumn("Names") { color in
                Text(color.name)
            }
            TableColumn("Colors") { color in
                color.desc
            }
        }
        .font(.title)
    }
}

struct Table_Intro_Previews: PreviewProvider {
    static var previews: some View {
        Table_Intro()
    }
}
