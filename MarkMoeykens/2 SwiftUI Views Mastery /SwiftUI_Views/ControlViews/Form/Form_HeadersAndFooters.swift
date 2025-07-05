//  Created by Mark Moeykens on 6/22/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Form_HeadersAndFooters : View {
    var body: some View {
        Form {
            Section {
                Text("You can add any view in a section header")
                Text("Notice the default foreground color is gray")
            } header: {
                Text("Section Header Text")
            }
            Section {
                Text("Here's an example of a section header with image and text")
            } header: {
                SectionTextAndImage(name: "People", image: "person.2.square.stack.fill")
            }
            Section {
                Text("Here is an example of a section footer")
            } footer: {
                Text("Total: $5,600.00").bold()
            }
        }
    }
}

struct SectionTextAndImage: View {
    var name: String
    var image: String
    var body: some View {
        HStack {
            Image(systemName: image).padding(.trailing)
            Text(name)
        }
        .padding()
        .font(.title)
        .foregroundStyle(Color.purple)
    }
}

struct Form_HeadersAndFooters_Previews : PreviewProvider {
    static var previews: some View {
        Form_HeadersAndFooters()
    }
}
