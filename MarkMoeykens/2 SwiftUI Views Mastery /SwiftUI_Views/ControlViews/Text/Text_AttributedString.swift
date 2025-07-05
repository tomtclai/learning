//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Text_AttributedString: View {
    @State private var name = "Big Mountain Studio"
    
    var myAttributedString: AttributedString {
        var attributedName = AttributedString(name)
        let big = attributedName.range(of: "Big")!
        let mountain = attributedName.range(of: "Mountain")!
        
        attributedName[big].foregroundColor = .green
        attributedName[mountain].foregroundColor = .red
        
        return attributedName
    }
    
    var body: some View {
        VStack(spacing: 40  ) {
            HeaderView("Text",
                       subtitle: "AttributedString",
                       desc: "You can apply attributes within a string and display that string using the Text view.",
                       back: .green, textColor: .white)
            
            Text(myAttributedString)
        }
        .font(.title)
    }
}

struct Text_AttributedString_Previews: PreviewProvider {
    static var previews: some View {
        Text_AttributedString()
    }
}
