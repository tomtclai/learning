// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Maintainability_ViewBuilderIntro: View {
    var body: some View {
        ScrollView {
            VStack {
                GroupBox {
                    Text("Employee Profile")
                        .font(.title.weight(.bold).width(.compressed))
                    Divider()
                    HStack {
                        Image(systemName: "person.circle")
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text("Susan McNall")
                                .font(.title2.weight(.medium))
                            Text("IT Department")
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                
                GroupBox {
                    Text("Expenses")
                        .font(.title.weight(.bold).width(.compressed))
                    Divider()
                    LabeledContent("Flight", value: 580, format: .currency(code: "USD"))
                    LabeledContent("Hotel", value: 1600, format: .currency(code: "USD"))
                    LabeledContent("Meals", value: 418, format: .currency(code: "USD"))
                }
                .padding()
            }
        }
    }
}

#Preview {
    Maintainability_ViewBuilderIntro()
}
