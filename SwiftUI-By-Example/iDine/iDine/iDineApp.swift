//
//  iDineApp.swift
//  iDine
//
//  Created by Lai, Tom on 7/28/23.
//

import SwiftUI

@main
struct iDineApp: App {
    @StateObject var order = Order()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(order)
        }
    }
}
