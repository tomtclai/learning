//
//  ContentView.swift
//  PhotoViewer
//
//  Created by Mark DiFranco on 2024-05-06.
//

import SwiftUI

struct ContentView: View {
    @GestureState var currenOffset = CGSize.zero
    @State var offset = CGSize.zero
    @GestureState var currentAngle = Angle.zero
    @State var angle = Angle.zero
    @GestureState var currentScale : CGFloat = 1.0
    @State var scale : CGFloat = 1.0
    var body: some View {
        VStack {
            Image(.cliffside)
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .offset(x: currenOffset.width + offset.width,
                        y: currenOffset.height + offset.height)
                .simultaneousGesture(dragGesture)
                .scaleEffect(currentScale * scale)
                .simultaneousGesture(zoomGesture)
                .rotationEffect(currentAngle + angle)
                .simultaneousGesture(rotateGesture)
            
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .updating($currenOffset) { value, state, _ in
                state = value.translation
            }
            .onEnded { value in
                offset = CGSize(width: offset.width + value.translation.width,
                                height: offset.height + value.translation.height)
            }
    }
    
    var rotateGesture: some Gesture {
        RotateGesture()
            .updating($currentAngle) { value, state, _ in
                state = value.rotation
            }
            .onEnded { value in
                angle = angle + value.rotation
            }
    }
    var zoomGesture: some Gesture {
        MagnifyGesture()
            .updating($currentScale) { value, state, _ in
                state = value.magnification
            }
            .onEnded { value in
                scale *= value.magnification
            }
    }
}

#Preview {
    ContentView()
}
