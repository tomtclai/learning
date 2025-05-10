//
//  CartItemModel.swift
//  FoodDelivery
//
//  Created by Mark DiFranco on 2024-05-09.
//

import SwiftUI

struct CartItemModel: Identifiable {
    let id = UUID()
    let image: ImageResource
    let name: String
    let price: String
    let quantity: String
}

extension CartItemModel {
    static let all: [CartItemModel] = [
        .burger,
        .fries,
        .soda
    ]

    static let burger = CartItemModel(
        image: .burger,
        name: "Deluxe Burger",
        price: "$6.99",
        quantity: "2"
    )
    static let fries = CartItemModel(
        image: .fries,
        name: "Large Fries",
        price: "$3.29",
        quantity: "1"
    )
    static let soda = CartItemModel(
        image: .soda,
        name: "Orange Pop",
        price: "$4.99",
        quantity: "2"
    )

    static let maki = CartItemModel(
        image: .maki,
        name: "Maki",
        price: "$5.99",
        quantity: "1"
    )
}
