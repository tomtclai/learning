//
//  GroceryListView.swift
//  SocialApp
//
//  Created by Tom Lai on 4/27/25.
//

import SwiftUI

struct GroceryListView: View {
    @State var groceries = [
        "Milk",
        "Bread",
        "Eggs",
        "Coffee",
        "Tomatoes",
        "Tomatoes",
    ]
    
    @State var selected: Int? = nil
    
    func setSelected(value: Int) {
        if selected == value { selected = nil }
        else {
            selected = value
        }
        print("selected \(String(describing: selected))")
    }
    var body: some View {
        
        List(groceries.indices, id: \.self) { idx in
            Text(groceries[idx])
                .listRowBackground( idx == selected ? Color.blue : Color.white)
                .foregroundStyle( idx == selected ? .white : .black)
                .swipeActions {
                    Button("Delete") {
                        groceries.remove(at: idx)
                    }
                    .tint(.red)
                }
                .onLongPressGesture(minimumDuration: 0.2) {
                    setSelected(value: idx)
                }
        }
        .navigationBarTitle("Grocery List")
    }
}

#Preview {
    GroceryListView()
}
