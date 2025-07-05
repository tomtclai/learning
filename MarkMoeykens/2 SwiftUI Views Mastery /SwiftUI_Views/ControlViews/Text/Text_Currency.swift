// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Text_Currency: View {
    @Environment(\.locale) private var locale: Locale
    @State private var amount = 36.72

    var body: some View {
        VStack(spacing: 10) {
            Text(amount, format: .currency(code: "USD"))
            Text(amount, format: .currency(code: "EUR"))
            Text(amount, format: .currency(code: "BRL"))
            Text(amount, format: .currency(code: "GBP"))
            Text(amount, format: .currency(code: "JPY"))
            Text(amount, format: .currency(code: "INR"))
            Text(amount, format: .currency(code: (locale.currency?.identifier ?? "USD")))
        }
        .font(.title)
    }
}

struct Text_Currency_Previews: PreviewProvider {
    static var previews: some View {
        Text_Currency()
    }
}
