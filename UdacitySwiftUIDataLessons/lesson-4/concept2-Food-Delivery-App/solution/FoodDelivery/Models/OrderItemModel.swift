//
//  OrderItemModel.swift
//  FoodDelivery
//
//  Created by Mark DiFranco on 2024-05-09.
//

import SwiftUI

struct OrderItemModel: Identifiable {
    let id = UUID()
    let restaurant: RestaurantModel
    let items: [CartItemModel]
    let total: String
}

extension OrderItemModel {
    static let all: [OrderItemModel] = [
        .firstOrder,
        .secondOrder
    ]
    static let firstOrder = OrderItemModel(
        restaurant: .burgerRestaurant,
        items: [.burger, .fries],
        total: "$17.27"
    )
    static let secondOrder = OrderItemModel(
        restaurant: .sushiRestaurant,
        items: [.maki],
        total: "$5.99"
    )
}
