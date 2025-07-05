//  Copyright © 2022 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

var jsonUserData = """
{
    "name": "Max Acavard",
    "address": {
        "street": "73 School St",
        "city": "Franconia",
        "state": "NH",
        "zipcode": "03580"
    }
}
"""

struct Json_UserWithAddress: Codable {
    var name = ""
    var address = Address()
    
    // Note: This struct can be inside or outside the parent struct.
    struct Address: Codable {
        var street = ""
        var city = ""
        var state = ""
        var zipcode = ""
    }
}

@Observable
class Json_ObjectsOO {
    var user = Json_UserWithAddress()
    var jsonError: Error?
    
    func fetch() {
        let jsonData = jsonUserData.data(using: .utf8)!
        
        do {
            user = try JSONDecoder().decode(Json_UserWithAddress.self, from: jsonData)
        } catch {
            jsonError = error
        }
    }
}

struct Json_ObjectsView: View {
    @State private var oo = Json_ObjectsOO()
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("JSON",
                       subtitle: "Objects",
                       desc: "You can also decode JSON objects inside objects structs inside of structs or classes inside of classes.",
                       back: .blue, textColor: .white)
            
            VStack(alignment: .leading) {
                Text(oo.user.name)
                Text(oo.user.address.street)
                HStack {
                    Text(oo.user.address.city)
                    Text(oo.user.address.state)
                    Text(oo.user.address.zipcode)
                }
            }
            Text(oo.jsonError?.localizedDescription ?? "")
        }
        .onAppear {
            oo.fetch()
        }
        .font(.title)
    }
}

struct Json_Objects_Previews: PreviewProvider {
    static var previews: some View {
        Json_ObjectsView()
    }
}

