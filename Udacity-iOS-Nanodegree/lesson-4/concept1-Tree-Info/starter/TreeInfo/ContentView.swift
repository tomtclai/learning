//
//  ContentView.swift
//  TreeInfo
//
//  Created by Mark DiFranco on 2024-05-08.
//

import SwiftUI

struct ContentView: View {
    let trees: [TreeModel]
    let gridItems = [GridItem(.adaptive(minimum: 100))]
    var body: some View {
        NavigationStack{
            ScrollView {
                LazyVGrid(columns: gridItems){
                    ForEach(trees) { tree in
                        NavigationLink(value: tree) {
                            TreeCell(tree: tree)
                        }.tint(tree.color)
                    }
                }
            }
            .navigationDestination(for: TreeModel.self) { tree in
                TreeDetailView(tree: tree)
                
            }
        }
    }
}

#Preview {
    ContentView(trees: TreeModel.all)
}
