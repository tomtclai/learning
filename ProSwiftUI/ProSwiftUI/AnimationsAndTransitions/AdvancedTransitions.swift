//
//  AdvancedTransitions.swift
//  ProSwiftUI
//
//  Created by Paul Hudson on 03/09/2022.
//

import SwiftUI

struct ConfettiModifier<T: ShapeStyle>: ViewModifier {
    @State private var circleSize = 0.00001  // Swift UI cannot draw 0 sized shapes
    @State private var strokeMultiplier = 1.0
    
    @State private var confettiIsHidden = true
    @State private var confettiMovement = 0.7
    @State private var confettiScale = 1.0
    
    @State private var contentsScale = 0.00001

    // Slowing it down to look at it 
    //    private let speed = 0.3
    private let speed = 5.0

    var color: T
    var size: Double

    func body(content: Content) -> some View {
        content.hidden()
            .padding(10) // Padding
            .overlay(
                ZStack {
                    GeometryReader { proxy in
                        Circle()
                            .strokeBorder(color, lineWidth: proxy.size.width / 2 * strokeMultiplier)
                            .scaleEffect(circleSize)

                        ForEach(0..<15) { i in
                            Circle()
                                .fill(color)
                                .frame(width: size + sin(Double(i)), height: size + sin(Double(i)))
                                .scaleEffect(confettiScale)
                                //.offset(x: proxy.size.width / 2 * confettiMovement)// boring
                                .offset(x: proxy.size.width / 2 * confettiMovement + (i.isMultiple(of: 2) ? size: 0))// random
                                .rotationEffect(.degrees(24 * Double(i)))
                                .offset(x: (proxy.size.width - size) / 2, y: (proxy.size.height - size) / 2)
                                .opacity(confettiIsHidden ? 0 : 1)

                        }
                    }
                    content.scaleEffect(contentsScale)

                }

                // Circle here
                // Stroke from outside to inside

            )
            .padding(-10) // Un pad
            .onAppear {

                withAnimation(.easeIn(duration: speed)){
                    circleSize = 1
                }
                // delay so that it runs second
                withAnimation(.easeOut(duration: speed).delay(speed)){
                    strokeMultiplier = 0.00001
                }

                withAnimation(.interpolatingSpring(stiffness: 50, damping: 5).delay(speed)) {
                    contentsScale = 1
                }

                withAnimation(.easeOut(duration: speed).delay(speed * 1.25)){
                    confettiIsHidden = false
                    confettiMovement = 1.2
                }

                withAnimation(.easeOut(duration: speed).delay(speed * 2)){
                    confettiScale = 0.00001
                }
            }
    }
}

extension AnyTransition {
    static var confetti: AnyTransition {
        .modifier(
            active: ConfettiModifier(color: .blue, size: 3),
            identity: ConfettiModifier(color: .blue, size: 3)
        )
    }

    static func confetti<T: ShapeStyle>(color: T = .blue, size: Double = 3.0) -> AnyTransition {
        AnyTransition.modifier(
            active: ConfettiModifier(color: color, size: size),
            identity: ConfettiModifier(color: color, size: size)
        )
    }
}


struct AdvancedTransitions: SelfCreatingView {
    @State private var isFavorite = false

    var body: some View {
        VStack(spacing: 60){
            ForEach([Font.body, Font.largeTitle, Font.system(size: 200)], id: \.self) { font in
                Button {
                    isFavorite.toggle()
                } label: {
                    if isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .transition(.confetti( color: .angularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center, startAngle: .zero, endAngle: .degrees(360))))
                    } else {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.gray)
                    }
                }.font(font)
            }
        }
    }
}

struct AdvancedTransitions_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedTransitions()
    }
}
