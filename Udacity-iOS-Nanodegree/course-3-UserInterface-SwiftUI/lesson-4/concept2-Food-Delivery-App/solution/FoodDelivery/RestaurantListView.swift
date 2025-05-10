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
        .tabItem {
            Label("Restaurants", systemImage: "takeoutbag.and.cup.and.straw")
        }
    }
}

#Preview {
    TabView {
        RestaurantListView()
    }
}
