//
//  ContentView.swift
//  FoodDelivery
//
//  Created by Mark DiFranco on 2024-05-09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RestaurantListView()
            CartView()
            OrderHistoryView()
        }
    }
}

#Preview {
    ContentView()
}
