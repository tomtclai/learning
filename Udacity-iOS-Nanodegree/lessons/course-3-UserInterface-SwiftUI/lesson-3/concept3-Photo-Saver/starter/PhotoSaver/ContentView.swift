//
//  ContentView.swift
//  PhotoSaver
//
//  Created by Mark DiFranco on 2024-05-08.
//

import SwiftUI

struct ContentView: View {
    let images: [ImageResource] = [.beach, .cliffs]

    var body: some View {
        List(images, id: \.self) { image in
            PhotoPostView(imageResource: image)
        }
        .listStyle(.plain)
    }
}

#Preview {
    ContentView()
}
