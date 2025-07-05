// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Text_ListFormatting: View {
    @State private var people = ["Mark", "Chase", "Rod", "Chris"]
    @State private var names = [PersonNameComponents(givenName: "Mark",
                                                     familyName: "Smith"),
                                PersonNameComponents(givenName: "Chase",
                                                     familyName: "Blue"),
                                PersonNameComponents(givenName: "Rod",
                                                     familyName: "Liber"),
                                PersonNameComponents(givenName: "Chris",
                                                     familyName: "Durts")]

    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Text",
                       subtitle: "List Formatting",
                       desc: "You can format an array of values so they are all comma separated and join the last element as specified.",
                       back: .green, textColor: .white)
            
            Text(people, format: .list(type: .and))
            Text(people, format: .list(type: .or))

            Text(people, format: .list(type: .and, width: .narrow))
            Text(people, format: .list(type: .and, width: .short))
            Text(people, format: .list(type: .and, width: .standard))
            
            Text(names, format: .list(memberStyle: .name(style: .abbreviated),
                                      type: .and, width: .short))
        }
        .font(.title)
    }
}

struct Text_ListFormatting_Previews: PreviewProvider {
    static var previews: some View {
        Text_ListFormatting()
    }
}
