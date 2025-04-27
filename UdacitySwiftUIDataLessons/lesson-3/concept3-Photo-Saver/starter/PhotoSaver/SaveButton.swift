//
//  SaveButton.swift
//  PhotoSaver
//
//  Created by Mark DiFranco on 2024-05-08.
//

import SwiftUI

struct SaveButton: View {
    @Binding var isSaved: Bool

    var body: some View {
        Button(action: {

            isSaved.toggle()

        }, label: {
            Image(systemName: isSaved ? "star.fill" : "star")
                .imageScale(.large)
                // Add animation effects here using isSaved
        })
        .foregroundStyle(isSaved ? .orange : .secondary)
        // Specify an animation to use
    }
}

private struct PreviewView: View {
    @State private var isSaved = false

    var body: some View {
        SaveButton(isSaved: $isSaved)
    }
}

#Preview {
    PreviewView()
}
