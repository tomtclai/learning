// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct TextField_LineLimit: View {
    @State private var text = "This is some longer text that will cause the text fields to scroll text."
    
    var body: some View {
        VStack(spacing: 24) {
            TextField("Enter Name", text: $text, axis: .vertical)
                .lineLimit(0)
            
            TextField("Enter Name", text: $text, axis: .vertical)
                .lineLimit(2)

            TextField("Enter Name", text: $text)
                .lineLimit(2)
            
            TextField("Enter Name", text: $text, axis: .vertical)
                .lineLimit(3)
            
            TextField("Enter Name", text: $text, axis: .vertical)
                .lineLimit(4)
            
            TextField("Enter Name", text: $text, axis: .vertical)
                .lineLimit(4...8)
        }
        .textFieldStyle(.roundedBorder)
        .font(.title)
        .padding()
    }
}

struct TextField_LineLimit_Previews: PreviewProvider {
    static var previews: some View {
        TextField_LineLimit()
    }
}
