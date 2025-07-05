// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct TextField_Axis: View {
    @State private var text = "This is some longer text that will cause the text fields to scroll text."
    
    var body: some View {
        VStack(spacing: 50.0) {
            Text("Scroll text horizontally")
                .bold()
            
            TextField("Enter text", text: $text, axis: .horizontal)
                .textFieldStyle(.roundedBorder)
            
            TextField("Enter text", text: $text, axis: .horizontal)
                .textFieldStyle(.plain)

            Text("Scroll text vertically")
                .bold()
            
            TextField("Enter text", text: $text, axis: .vertical)
                .lineLimit(2)
                .textFieldStyle(.roundedBorder)
            
            TextField("Enter text", text: $text, axis: .vertical)
                .textFieldStyle(.plain)
                .lineLimit(2)
        }
        .font(.title)
        .padding()
    }
}

struct TextField_Axis_Previews: PreviewProvider {
    static var previews: some View {
        TextField_Axis()
    }
}
