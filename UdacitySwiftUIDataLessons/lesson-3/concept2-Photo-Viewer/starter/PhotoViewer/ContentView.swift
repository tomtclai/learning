//
//  ContentView.swift
//  PhotoViewer
//
//  Created by Mark DiFranco on 2024-05-06.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack {
            Image(.cliffside)
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                // add gestures here
        }
    }
}

#Preview {
    ContentView()
}
