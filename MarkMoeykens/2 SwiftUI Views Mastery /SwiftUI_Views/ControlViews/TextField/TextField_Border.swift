// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct TextField_Border: View {
    @State private var textFieldData = ""
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("TextField", subtitle: "Border",
                       desc: "Use the border modifier to apply a ShapeStyle to the border of the text field.",
                       back: .orange)
            
            Group {
                TextField("Data", text: $textFieldData)
                    .padding(5)
                    .border(Color.orange)
                
                TextField("Data", text: $textFieldData)
                    .padding(5)
                    .border(.ultraThickMaterial, width: 4)
                
                TextField("Data", text: $textFieldData)
                    .padding(5)
                    .border(.tertiary, width: 5)
                
                TextField("Data", text: $textFieldData)
                    .padding(5)
                    .border(LinearGradient(colors: [.orange, .pink],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing), width: 5)
            }
            .padding(.horizontal)
        }
        .font(.title)
    }
}

struct TextField_Border_Previews: PreviewProvider {
    static var previews: some View {
        TextField_Border()
    }
}
