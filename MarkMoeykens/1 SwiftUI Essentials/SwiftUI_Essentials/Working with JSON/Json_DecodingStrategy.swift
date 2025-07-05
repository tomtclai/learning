//  Copyright © 2022 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

var jsonFruitData = """
{
    "fruit_name": "Apple",
    "fruit_color": "Green"
}
"""

struct Json_Fruit: Codable {
    var fruitName: String = ""
    var fruitColor: String = ""
}

@Observable
class Json_DecodingStrategyOO {
    var fruitInfo = Json_Fruit()
    var jsonError: Error?
    
    func fetch() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let jsonData = jsonFruitData.data(using: .utf8)!
        
        do {
            fruitInfo = try decoder.decode(Json_Fruit.self, from: jsonData)
        } catch {
            jsonError = error
        }
    }
}

struct Json_DecodingStrategyView: View {
    @State private var oo = Json_DecodingStrategyOO()
    
    var body: some View {
        VStack {
            HeaderView("JSON",
                       subtitle: "Decoding Strategy",
                       desc: "Sometimes the JSON key names don't match the naming convention you have (snake case vs camel case). You can specify a different key coding strategy to handle this.",
                       back: .blue, textColor: .white)
            
            Text("Name: \(oo.fruitInfo.fruitName)")
            Text("Color: \(oo.fruitInfo.fruitColor)")
            Text(oo.jsonError?.localizedDescription ?? "")
        }
        .onAppear {
            oo.fetch()
        }
        .font(.title)
    }
}

struct Json_DecodingStrategy_Previews: PreviewProvider {
    static var previews: some View {
        Json_DecodingStrategyView()
    }
}
