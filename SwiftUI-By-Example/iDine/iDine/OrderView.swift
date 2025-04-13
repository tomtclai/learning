//
//  OrderView.swift
//  iDine
//
//  Created by Lai, Tom on 7/28/23.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var order: Order
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(order.items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("$\(item.price)")
                        }
                    }
                }

                Section {
                    NavigationLink("Place Order") {
                        CheckoutView()
                    }
                }
            }
            .navigationTitle("Order")
        }
    }
}


struct OrderView_Previews: PreviewProvider {
    static var order : Order {
        let thisOrder = Order()
        thisOrder.add(item: MenuItem.example)
        return thisOrder
    }
    static var previews: some View {
        OrderView().environmentObject(order)
    }
}
