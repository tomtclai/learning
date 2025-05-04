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
        ZStack {
            
            Color(tree.color)
                .opacity(0.3)
                
            VStack {
                Image(tree.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .clipped()
                
                VStack(alignment: .center) {
                    Text(tree.name)
                    Text(tree.family)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
            
        }
        

    }
}

#Preview {
    List {
        TreeCell(tree: .palmTree)
    }
}
