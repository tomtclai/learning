//
//  RestaurantListView.swift
//  FoodDelivery
//
//  Created by Mark DiFranco on 2024-05-09.
//

import SwiftUI

struct RestaurantListView: View {
    var body: some View {
        NavigationStack {
            List(RestaurantModel.all) { restaurant in
                RestaurantCell(restaurant: restaurant)
            }
            .listStyle(.grouped)
            .navigationTitle("Restaurants")
        }
        // Add a tab item for the tab label
    }
}

#Preview {
    TabView {
        RestaurantListView()
    }
}
