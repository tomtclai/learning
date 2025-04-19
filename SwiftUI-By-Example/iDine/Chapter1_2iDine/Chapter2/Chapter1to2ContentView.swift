//
//  Chapter1to2ContentView.swift
//  iDine
//
//  Created by Lai, Tom on 7/28/23.
//

import SwiftUI

struct Chapter1to2ContentView: View {
    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    var body: some View {
        NavigationStack {
            List {
                ForEach(menu) { section in
                    Section(section.name) {
                        ForEach(section.items) { item in
                            NavigationLink(value: item) {
                                ItemRow(item: item)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: MenuItem.self) { item in
                ItemDetail(item: item)
            }
        }
        .navigationTitle("Menu")
        .listStyle(GroupedListStyle())
    }
}


struct Chapter1to2ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Chapter1to2ContentView()
    }
}
