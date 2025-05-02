//
//  OrderHistoryView.swift
//  FoodDelivery
//
//  Created by Mark DiFranco on 2024-05-09.
//

import SwiftUI

struct OrderHistoryView: View {
    var body: some View {
        NavigationStack {
            List(OrderItemModel.all) { orderItem in
                Section {
                    OrderItemCell(orderItem: orderItem)
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Order History")
        }
        // Add a tab item for the tab label
    }
}

#Preview {
    TabView {
        OrderHistoryView()
    }
}
