// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Text_PersonNameComponents: View {
    @State private var name = PersonNameComponents(namePrefix: "Dr.",
                                                   givenName: "Jaqueline",
                                                   middleName: "Fernanda",
                                                   familyName: "Cruz",
                                                   nameSuffix: "EdD",
                                                   nickname: "Jaque")

    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Text",
                       subtitle: "PersonNameComponents",
                       desc: "If the type is a name, you can format it to show the name in different ways.",
                       back: .green, textColor: .white)
            
            Text(name, format: .name(style: .abbreviated))
            Text(name, format: .name(style: .short))
            Text(name, format: .name(style: .medium))
            Text(name, format: .name(style: .long))
                .lineLimit(1)
                .minimumScaleFactor(0.9)
        }
        .font(.title)
    }
}

struct Text_PersonNameComponents_Previews: PreviewProvider {
    static var previews: some View {
        Text_PersonNameComponents()
    }
}
