//
//  App.swift
//  iDine
//
//  Created by Lai, Tom on 7/28/23.
//

import SwiftUI

@main
struct MyApp: App {
    @StateObject var order = Order()
    @StateObject var favs = Favorites()
    var body: some Scene {
        WindowGroup {
            Chapter4ImageTestView()
//            Chapter3TextTestingView()
//            MainView()
//                .environmentObject(order)
//                .environmentObject(favs)
        }
    }
}
