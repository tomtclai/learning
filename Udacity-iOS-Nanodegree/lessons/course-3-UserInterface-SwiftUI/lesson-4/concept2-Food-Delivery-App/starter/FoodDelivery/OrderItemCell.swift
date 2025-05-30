//
//  OrderItemCell.swift
//  FoodDelivery
//
//  Created by Mark DiFranco on 2024-05-09.
//

import SwiftUI

struct OrderItemCell: View {
    let orderItem: OrderItemModel

    var body: some View {
        VStack {
            HStack {
                Image(orderItem.restaurant.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 13))

                Text(orderItem.restaurant.name)
                    .font(.title2)
                    .bold()

                Spacer()

                Text(orderItem.total)
                    .font(.title3)
                    .bold()
            }

            Divider()

            ForEach(orderItem.items) { item in
                HStack {
                    Image(item.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                    Text(item.name)
                        .bold()

                    Spacer()

                    Text("\(item.quantity) x \(item.price)")
                }
            }
        }
    }
}

#Preview {
    List {
        OrderItemCell(orderItem: .firstOrder)
    }
}
