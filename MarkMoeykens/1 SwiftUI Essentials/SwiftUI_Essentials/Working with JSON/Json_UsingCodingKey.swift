//  Copyright © 2022 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

var jsonVegetableData = """
{
    "01_vegatable_name": "Beans",
    "02_vegetable_color": "Yellow",
    "quantity": 10
}
"""

struct Json_Vegetable: Codable {
    var name = ""
    var color = ""
    var quantity = 0
    
    enum CodingKeys: String, CodingKey {
        case name = "01_vegatable_name"
        case color = "02_vegetable_color"
        case quantity // Still needed (all fields will need a key)
    }
}

@Observable
class Json_UsingCodingKeyOO {
    var vegetable = Json_Vegetable()
    var jsonError: Error?
    
    func fetch() {
        let decoder = JSONDecoder()
        
        let jsonData = jsonVegetableData.data(using: .utf8)!
        
        do {
            vegetable = try decoder.decode(Json_Vegetable.self, from: jsonData)
        } catch {
            jsonError = error
        }
    }
}

struct Json_UsingCodingKeyView: View {
    @State private var oo = Json_UsingCodingKeyOO()
    
    var body: some View {
        VStack {
            HeaderView("JSON",
                       subtitle: "Using CodingKey",
                       desc: "In some cases you get names in JSON that do not match up to your destination object at all. Use a CodingKeys enum to map them.",
                       back: .blue, textColor: .white)
            
            Text("Name: \(oo.vegetable.name)")
            Text("Color: \(oo.vegetable.color)")
            Text("Quantity: \(oo.vegetable.quantity)")
            Text(oo.jsonError?.localizedDescription ?? "")
        }
        .onAppear {
            oo.fetch()
        }
        .font(.title)
    }
}

struct Json_UsingCodingKey_Previews: PreviewProvider {
    static var previews: some View {
        Json_UsingCodingKeyView()
    }
}

