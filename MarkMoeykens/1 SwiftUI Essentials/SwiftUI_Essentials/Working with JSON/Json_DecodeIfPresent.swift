// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

// View
import SwiftUI

var jsonDrinkOrder1 = """
{
    "drink": "Latte",
    "milk": "Whole",
    "sugarCubes": 2
}
"""

var jsonDrinkOrder2 = """
{
    "drink": "Latte",
    "milk": null
}
"""

struct DrinkOrder: Codable {
    var drink = ""
    var milk: String?
    var sugarCubes: Int = 0
    
    enum Keys: CodingKey {
        case drink
        case milk
        case sugarCubes
    }
    
    init() { }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        // Values that are always present
        self.drink = try container.decode(String.self, forKey: .drink)
        self.milk = try container.decode(String?.self, forKey: .milk)

        // Values that are sometimes present
        self.sugarCubes = try container.decodeIfPresent(Int.self, forKey: .sugarCubes) ?? 0
    }
}

@Observable
class Json_DecodeIfPresentOO {
    var drinkOrder: DrinkOrder = DrinkOrder()
    var jsonError: Error?

    func fetch() {
        let jsonData = jsonDrinkOrder2.data(using: .utf8)!
        
        do {
            drinkOrder = try JSONDecoder().decode(DrinkOrder.self, from: jsonData)
        } catch {
            jsonError = error
        }
    }
}

struct Json_DecodeIfPresentView: View {
    @State private var oo = Json_DecodeIfPresentOO()
    
    var body: some View {
        VStack {
            HeaderView("JSON",
                       subtitle: "Decode if Present",
                       desc: "You might be using a service that may or may not return some values. In this case, you really have to customize the decoding.",
                       back: .blue, textColor: .white)
            
            GroupBox("Drink Order") {
                Text(oo.drinkOrder.drink)
                
                if let milk = oo.drinkOrder.milk {
                    Text("Milk: \(milk)")
                }
                
                Text("Sugar: \(oo.drinkOrder.sugarCubes)")
            }
            .padding()
            
            Text(oo.jsonError?.localizedDescription ?? "")
        }
        .task {
            oo.fetch()
        }
        .font(.title)
    }
}

struct Json_DecodeIfPresent_Previews: PreviewProvider {
    static var previews: some View {
        Json_DecodeIfPresentView()
    }
}

