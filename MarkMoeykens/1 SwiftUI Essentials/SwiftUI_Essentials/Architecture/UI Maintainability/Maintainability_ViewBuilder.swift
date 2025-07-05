// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Maintainability_ViewBuilder: View {
    var body: some View {
        ScrollView {
            VStack {
                CardView(title: "Employee Profile") {
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
                
                CardView(title: "Expenses") {
                    LabeledContent("Flight", value: 580, format: .currency(code: "USD"))
                    LabeledContent("Hotel", value: 1600, format: .currency(code: "USD"))
                    LabeledContent("Meals", value: 418, format: .currency(code: "USD"))
                }
            }
        }
    }
}

#Preview {
    Maintainability_ViewBuilder()
}
