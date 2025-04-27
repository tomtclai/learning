//
//  CartView.swift
//  FoodDelivery
//
//  Created by Mark DiFranco on 2024-05-09.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        NavigationStack {
            VStack {
                List(CartItemModel.all) { cartItem in
                    CartItemCell(cartItem: cartItem)
                }
                .listStyle(.grouped)

                Text("Total: $27.25")
                    .bold()
                    .foregroundStyle(.secondary)

                Button(action: {
                    // Order food
                }, label: {
                    HStack {
                        Spacer()
                        Label("Checkout", systemImage: "cart.fill")
                            .padding(4)
                        Spacer()
                    }
                })
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
            }
            .navigationTitle("Cart")
        }
        .tabItem {
            Label("Cart", systemImage: "cart")
        }
    }
}

#Preview {
    TabView {
        CartView()
    }
}
