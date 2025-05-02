//
//  CartItemCell.swift
//  FoodDelivery
//
//  Created by Mark DiFranco on 2024-05-09.
//

import SwiftUI

struct CartItemCell: View {
    let cartItem: CartItemModel

    var body: some View {
        HStack {
            Image(cartItem.image)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 13))

            VStack(alignment: .leading) {
                Text(cartItem.name)
                    .font(.title2)
                    .bold()
                Text(cartItem.price)
                    .foregroundStyle(.secondary)
                    .bold()
            }

            Spacer()

            Text(cartItem.quantity)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    List {
        CartItemCell(cartItem: .burger)
    }
}
