//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct List_AlternatesRowBackgrounds: View {
    @State private var cars = ["Alpha Romeo", "Aston Martin", "Audi", "Bentley", "BMW", "Bugatti", "Ferrari", "Infiniti"]
    
    var body: some View {
        VStack(spacing: 20.0) {
            HeaderView("List",
                       subtitle: "AlternatesRowBackgrounds",
                       desc: "When using a listStyle modifier, you can also specify if you want the rows to alternate their background colors.")

            List(cars, id: \.self) { car in
                Text(car)
            }
//            macOS only
//            .listStyle(.automatic(alternatesRowBackgrounds: true))
        }
        .font(.title)
    }
}

struct List_AlternatesRowBackgrounds_Previews: PreviewProvider {
    static var previews: some View {
        List_AlternatesRowBackgrounds()
    }
}
