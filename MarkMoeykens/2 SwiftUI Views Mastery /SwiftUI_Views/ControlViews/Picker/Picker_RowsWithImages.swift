//
//  Created by Mark Moeykens on 6/18/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.
//

import SwiftUI

struct Picker_RowsWithImages : View {
    @State private var youTuberName = "Mark"
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Picker",
                       subtitle: "Rows with Images",
                       desc: "Row customization is limited. Adding an image will work.")
            Picker(selection: $youTuberName, label: Text("")) {
                Row(name: "Paul").tag("Paul")
                Row(name: "Chris").tag("Chris")
                Row(name: "Mark").tag("Mark")
                Row(name: "Scott").tag("Scott")
                Row(name: "Meng").tag("Meng")
            }
            .pickerStyle(.wheel)
            .padding(.horizontal)
            Spacer()
        }
        .font(.title)
    }
}

fileprivate struct Row : View {
    var name: String
    
    var body: some View {
        HStack {
            Label(title: { Text(name) },
                icon: { Image(systemName: "person.fill")
                        .foregroundStyle(Color.red) }
            )
        }
    }
}

struct Picker_RowsWithImages_Previews : PreviewProvider {
    static var previews: some View {
        Picker_RowsWithImages()
            .preferredColorScheme(.dark)
    }
}
