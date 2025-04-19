//
//  ItemDetail.swift
//  iDine
//
//  Created by Lai, Tom on 7/28/23.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var favs: Favorites
    
    func deleteItems(at offsets: IndexSet) {
        favs.items.remove(atOffsets: offsets)
    }
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(favs.items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("$\(item.price)")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                EditButton()
            }
        }
    }
}


struct FavoriteView_Previews: PreviewProvider {
    static var favs : Favorites {
        let list = Favorites()
        list.add(item: MenuItem.example)
        return list
    }
    static var previews: some View {
        FavoriteView().environmentObject(favs)
    }
}
