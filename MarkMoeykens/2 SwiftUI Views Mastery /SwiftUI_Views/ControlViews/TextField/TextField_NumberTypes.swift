// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct TextField_NumberTypes: View {
    @State private var number = 34
    
    var body: some View {
        VStack(spacing: 10) {
            HeaderView("TextField", subtitle: "Number Types",
                       desc: "Use the value and format initializer to bind a TextField with a numeric type.",
                       back: .orange)
            
            TextField("Age", value: $number, format: .number)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .padding(.horizontal)
            
            TextField("Percent", value: $number, format: .percent)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .padding(.horizontal)
            
            TextField("Amount", value: $number, format: .currency(code: "USD"))
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .padding(.horizontal)
        }
        .font(.title)
    }
}

struct TextField_Numbers_Previews: PreviewProvider {
    static var previews: some View {
        TextField_NumberTypes()
    }
}
