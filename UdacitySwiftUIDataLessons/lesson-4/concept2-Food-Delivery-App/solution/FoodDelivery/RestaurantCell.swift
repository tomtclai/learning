//
//  RestaurantCell.swift
//  FoodDelivery
//
//  Created by Mark DiFranco on 2024-05-09.
//

import SwiftUI

struct RestaurantCell: View {
    let restaurant: RestaurantModel

    var body: some View {
        HStack {
            Image(restaurant.image)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 13))

            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.title2)
                    .bold()
                Text(restaurant.starCount)
                    .bold()
                    .foregroundStyle(.orange)
            }

            Spacer()

            Text(restaurant.distance)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    List {
        RestaurantCell(restaurant: .burgerRestaurant)
    }
}
