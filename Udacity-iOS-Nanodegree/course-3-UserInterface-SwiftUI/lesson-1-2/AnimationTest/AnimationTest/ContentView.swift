//
//  ContentView.swift
//  AnimationTest
//
//  Created by Tom Lai on 4/29/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        KeyframeView()
    }
}

#Preview {
    ContentView()
}
struct AnimationView: View {
    @State private var opacity: Double = 0
    @State private var offset: CGFloat = 500
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 200

    var body: some View {
        Text("Hello, World!")
            .offset(y: offset)
            .scaleEffect(scale)
            .opacity(opacity)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation {
                    opacity = 1
                    offset = 0

                }
                withAnimation(.easeOut(duration: 1).delay(1)) {
                    scale = 1
                }
                withAnimation (Animation.linear(duration: 2).repeatCount(2, autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}


struct CustomPathView: View {
    @State private var moveAlongPath = false

    var body: some View {
        Path {
            path in path.addArc(center: .init(x: 190, y: 350), radius: 170, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
        }
        .trim(from: 0, to: moveAlongPath ? 1 : 0)
        .stroke(Color.blue, lineWidth: 4)
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                moveAlongPath = true
            }
        }
    }
}


struct Transform3DView: View {
    @State private var rotation3D = 0.0
    
    var body: some View {
        Text("3D Transform")
            .rotation3DEffect(.degrees(rotation3D), axis: (x: 1, y: 1, z: 0))
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever()) {
                     rotation3D = 405
            }
        }
    }
}


struct KeyframeView: View {
    @State private var offset: CGFloat = 0
    @State private var rotation3D = 0.0

    var body: some View {
        Text("Keyframe")
            .offset(x: offset)
            .rotation3DEffect(.degrees(rotation3D), axis: (x: 1, y: 1, z: 0))
            .onAppear {
                withAnimation(Animation.easeIn(duration: 1).delay(1)) {
                    offset += 100
                }
                withAnimation(Animation.easeOut(duration: 1).delay(2)) {
                    offset -= 200
                }
                withAnimation(Animation.easeOut(duration: 1).delay(3)) {
                    offset = 0
                    rotation3D = 360
                }
            }
    }
}
