//
//  CheckoutView.swift
//  iDine
//
//  Created by tom on 7/30/23.
//

import SwiftUI

struct CheckoutView: View {
    @State private var paymentType = "Cash"
    let paymentTypes = ["Cash", "Credit Card", "iDine Points"]
    var body: some View {
        VStack {
            Section {
                Picker("How do you want to pay?", selection: $paymentType) {
                    ForEach(paymentTypes, id: \.self) {
                        Text($0)
                    }
                }
            }
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CheckoutView_Preview: PreviewProvider {
    static var previews: some View {
        CheckoutView().environmentObject(Order())
    }
}
