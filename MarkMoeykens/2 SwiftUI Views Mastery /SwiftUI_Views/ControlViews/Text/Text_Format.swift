// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Text_Format: View {
    @State private var value = 12.34

    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Text",
                       subtitle: "Format",
                       desc: "There is an initializer for the Text view that allows you to convert a nonstring type to a string with a specific format.",
                       back: .green, textColor: .white)
            
            Text(value, format: .number)
            Text(value, format: .percent)
            Text(value, format: .currency(code: "GBP"))
        }
        .font(.title)
    }
}

struct Text_Format_Previews: PreviewProvider {
    static var previews: some View {
        Text_Format()
    }
}
