//
//  ContentView.swift
//  TreeInfo
//
//  Created by Mark DiFranco on 2024-05-08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(TreeModel.all) { tree in
                NavigationLink {
                    TreeDetailView(tree: tree)
                } label: {
                    TreeCell(tree: tree)
                }
            }
            .navigationTitle("Trees")
        }
    }
}

#Preview {
    ContentView()
}
