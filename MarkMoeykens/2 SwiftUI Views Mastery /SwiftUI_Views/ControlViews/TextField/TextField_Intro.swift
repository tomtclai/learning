//  Created by Mark Moeykens on 6/13/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.
//

import SwiftUI

struct TextField_Intro : View {
    @State private var textFieldData = ""
    
    var body: some View {
        VStack(spacing: 10) {
            HeaderView("TextField", subtitle: "Introduction",
                       desc: "It is required to bind text fields to a variable when using them so you can get/set the text. \nBy default, TextFields have a plain TextFieldStyle that has no visual content to be seen.",
                       back: .orange)
            Image(systemName: "arrow.down.circle")
            TextField("This is a text field", text: $textFieldData)
                .padding(.horizontal)
            Image(systemName: "arrow.up.circle")
            
            Text("Use .textFieldStyle (.roundedBorder) to show a border.")
                .frame(maxWidth: .infinity).padding()
                .background(Color.orange)
            TextField("", text: $textFieldData)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
        }
        .font(.title)
    }
}


struct TextField_Intro_Previews : PreviewProvider {
    static var previews: some View {
        TextField_Intro()
    }
}
