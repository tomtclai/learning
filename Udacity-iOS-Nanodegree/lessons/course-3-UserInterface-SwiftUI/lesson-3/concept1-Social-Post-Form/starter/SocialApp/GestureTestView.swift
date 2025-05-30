//
//  ContentView.swift
//  SocialApp
//
//  Created by Mark DiFranco on 2024-05-05.
//

import SwiftUI

struct GestureTestView: View {
    @GestureState private var dragOffset = CGSize.zero
    @State private var offset = CGSize.zero
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .offset(x: offset.width + dragOffset.width,
                        y: offset.height + dragOffset.height)
                .gesture(dragGesture)
                .font(.system(size: 100))
        }
    }
    var dragGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, trans in
                state = value.translation
            }
            .onEnded { value in
                offset = CGSize(
                    width: offset.width + value.translation.width,
                    height: offset.height + value.translation.height
                )
            }
    }
}



#Preview {
    GestureTestView()
}
