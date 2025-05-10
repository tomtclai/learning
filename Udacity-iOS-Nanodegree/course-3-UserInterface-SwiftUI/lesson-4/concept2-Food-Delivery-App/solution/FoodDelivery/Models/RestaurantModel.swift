//
//  RestaurantModel.swift
//  FoodDelivery
//
//  Created by Mark DiFranco on 2024-05-09.
//

import SwiftUI

struct RestaurantModel: Identifiable {
    let id = UUID()
    let image: ImageResource
    let name: String
    let starCount: String
    let distance: String
}

extension RestaurantModel {
    static let all: [RestaurantModel] = [
        .burgerRestaurant,
        .sushiRestaurant,
        .mexicanRestaurant
    ]

    static let burgerRestaurant = RestaurantModel(
        image: .burgerRestaurant,
        name: "Burger Joint",
        starCount: "4.6 Stars",
        distance: "11 mi"
    )

    static let sushiRestaurant = RestaurantModel(
        image: .sushiRestaurant,
        name: "Sushi Place",
        starCount: "4.9 Stars",
        distance: "15 mi"
    )

    static let mexicanRestaurant = RestaurantModel(
        image: .mexicanRestaurant,
        name: "Mexican Restaurant",
        starCount: "4.7 Stars",
        distance: "22 mi"
    )
}
