//  Copyright © 2022 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

// JSON: JavaScript Object Notation
// Notice how different types are notated
var userJsonData = """
{
    "name": "Max",
    "age": 28,
    "married": true,
    "pets": ["Rover", "Milo"],
    "email": null
}
"""
@Observable
class Json_IntroOO {
    var data = ""
    
    func fetch() {
        data = userJsonData
    }
}

struct Json_IntroView: View {
    @State private var oo = Json_IntroOO()
    
    var body: some View {
        VStack {
            HeaderView("JSON",
                       subtitle: "Introduction",
                       desc: "JSON is a JavaScript language way to describe object data. By itself it's not very useful in a SwiftUI app. We want to take that data and put it into either a struct or class.",
                       back: .blue, textColor: .white)
            
            Text(oo.data)
        }
        .onAppear {
            oo.fetch()
        }
        .font(.title)
    }
}

struct Json_Intro_Previews: PreviewProvider {
    static var previews: some View {
        Json_IntroView()
    }
}
