//  Copyright © 2022 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

var jsonString = """
{
    "name": "Max",
    "age": 28,
    "married": true,
    "pets": ["Rover", "Milo"],
    "email": null
}
"""

struct Json_User: Codable {
    var name = ""
    var age = 0
    var married = false
    var pets: [String] = []
    var email: String?
}

@Observable
class Json_DecodingOO {
    var user = Json_User()
    var jsonError: Error?
    
    func fetch() {
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        do {
            user = try decoder.decode(Json_User.self, from: jsonData)
        } catch {
            jsonError = error
        }
    }
}

struct Json_DecodingView: View {
    @State private var oo = Json_DecodingOO()
    
    var body: some View {
        VStack {
            HeaderView("JSON",
                       subtitle: "Decoding",
                       desc: "JSON decoding is the process of taking a JSON data and putting the data into a struct or class.",
                       back: .blue, textColor: .white)
            Form {
                Label(oo.user.name, systemImage: "person")
                Label(oo.user.age.description, systemImage: "calendar.badge.clock")
                Label(oo.user.married.description, systemImage: "person.2")
                Label(oo.user.pets.joined(separator: ", "), systemImage: "pawprint")
                Label(oo.user.email ?? "none specified", systemImage: "envelope")
            }
            Text(oo.jsonError?.localizedDescription ?? "")
        }
        .onAppear {
            oo.fetch()
        }
        .font(.title)
    }
}

struct Json_Decoding_Previews: PreviewProvider {
    static var previews: some View {
        Json_DecodingView()
    }
}
