//  Copyright © 2022 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI
/*
 Changes to the enum:
 1. Add CaseIterable
 2. Add Identifiable
 3. Add an id
 
 enum CarType: String, Codable, CaseIterable, Identifiable {
     var id: String { self.rawValue }
     
     case foreign
     case domestic
 }
 */
struct Json_Enums_BindToPicker: View {
    @State private var oo = Json_EnumsOO()
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("JSON",
                       subtitle: "Enums - Binding to Picker",
                       desc: "Example of how to decode JSON into enums and bind enum to a Picker.",
                       back: .blue, textColor: .white)

            Text(oo.carData.name)
            
            Picker("Car Type", selection: $oo.carData.type) {
                ForEach(CarType.allCases) { type in
                    Text(type.rawValue.capitalized)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Text(oo.carData.type.rawValue.capitalized)
            Text(oo.jsonError?.localizedDescription ?? "")
        }
        .onAppear {
            oo.fetch()
        }
        .font(.title)
    }
}

struct Json_Enums_BindToPicker_Previews: PreviewProvider {
    static var previews: some View {
        Json_Enums_BindToPicker()
    }
}
