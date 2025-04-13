//
//  CheckoutView.swift
//  iDine
//
//  Created by tom on 7/30/23.
//

import SwiftUI

struct CheckoutView: View {
    @State private var addLoyaltyDetails = false
    @State private var loyaltyNumber = ""
    @State private var paymentType = "Cash"
    @State private var tipAmount = 15
    @State private var showingPaymentAlert = false
    @EnvironmentObject var order: Order
    let tipAmounts = [10, 15, 20, 25, 0]
    let paymentTypes = ["Cash", "Credit Card", "iDine Points"]
    var totalPrice: String {
        let total = Double(order.total)
        let tip = total * Double(tipAmount) / 100
        return (total + tip).formatted(.currency(code: "USD"))
        
    }
    var body: some View {
        Form {
            Section {
                Picker("How do you want to pay?", selection: $paymentType) {
                    ForEach(paymentTypes, id: \.self) {
                        Text($0)
                    }
                }
                Toggle("Add iDine loyalty card", isOn: $addLoyaltyDetails.animation())
                if addLoyaltyDetails {
                    TextField("Enter your iDine ID", text: $loyaltyNumber)
                }
            }
            Section("Add a tip?") {
                Picker("Percentage", selection: $tipAmount) {
                    ForEach(tipAmounts, id: \.self) {
                        Text("\($0)%")
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section("Total: \(totalPrice)") {
                Button("Confirm order") {
                    showingPaymentAlert.toggle()
                }
            }
        }
        .alert("Order confirmed", isPresented: $showingPaymentAlert) {
            // add buttons here
        } message: {
            Text("Your total was \(totalPrice) - thank you!")
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
