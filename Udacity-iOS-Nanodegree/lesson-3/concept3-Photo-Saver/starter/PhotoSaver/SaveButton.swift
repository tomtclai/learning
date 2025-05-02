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
            withAnimation {
                isSaved.toggle()
            }
        }, label: {
            Image(systemName: isSaved ? "star.fill" : "star")
                .imageScale(.large)
                .rotationEffect(isSaved ? .degrees(360) : .degrees(0))
                .scaleEffect(isSaved ? 5.3 : 3)
        })
        .foregroundStyle(isSaved ? .orange : .secondary)
        .animation(.bouncy(duration: 0.5), value: isSaved)
    }
}

struct MySaveButton: View {
    @Binding var isSaved: Bool
    @State var rotationAngle: Angle = Angle(degrees: 0)
    @State var scale = 1.0
    var body: some View {
        Button(
action: {
            isSaved.toggle()
            rotationAngle = Angle(degrees: 360)
            scale = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                scale = 1.0
                rotationAngle = Angle(degrees: 0)
            }
        },
 label: {
            Image(systemName: isSaved ? "star.fill" : "star")
                .imageScale(.large)

                .rotationEffect(rotationAngle)
                .scaleEffect(scale)

        })
        .foregroundStyle(isSaved ? .orange : .secondary)
        .animation(.easeInOut, value: rotationAngle)
        .animation(.default, value: scale)

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
