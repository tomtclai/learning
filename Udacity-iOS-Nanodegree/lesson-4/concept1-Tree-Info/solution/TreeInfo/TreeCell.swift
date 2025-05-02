//
//  TreeCell.swift
//  TreeInfo
//
//  Created by Mark DiFranco on 2024-05-08.
//

import SwiftUI

struct TreeCell: View {
    let tree: TreeModel

    var body: some View {
        HStack {
            Image(tree.image)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .clipped()

            VStack(alignment: .leading) {
                Text(tree.name)
                Text(tree.family)
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }

            Spacer()
        }

    }
}

#Preview {
    List {
        TreeCell(tree: .palmTree)
    }
}
