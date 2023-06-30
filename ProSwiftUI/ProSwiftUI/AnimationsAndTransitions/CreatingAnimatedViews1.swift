//
//  CreatingAnimatedViews1.swift
//  ProSwiftUI
//
//  Created by Paul Hudson on 03/09/2022.
//

import SwiftUI

extension CreatingAnimatedViews1 {
    struct CountingText: View, Animatable {
        var value: Double
        var fractionLength = 8
        
        var animatableData: Double {
            get { value }
            set { value = newValue }
        }
        
        var body: some View {
            Text(value.formatted(.number.precision(.fractionLength(fractionLength))))
        }
    }

    struct TypingAnimationText: View, Animatable {
        @Environment(\.accessibilityVoiceOverEnabled) var accessbilityVoiceOverEnabled

        var string: String
        var count = 0

        var animatableData: Double{
            get { Double(count) }
            set { count = Int(max(0, newValue)) }
        }
        var body: some View {
            if accessbilityVoiceOverEnabled {
                Text(string)
            } else {
                ZStack{
                    Text(string.prefix(count))
                    Text(string.prefix(count)).hidden(true)
                }
            }
        }
    }
}

struct CreatingAnimatedViews1: SelfCreatingView {

    @State private var value = 0
    let message = "hello world"

    var body: some View {
        VStack{
            //        CountingText(value: value)
            //            .onTapGesture {
            //                withAnimation(.linear) {
            //                    value = Double.random(in: 1...1000)
            //                }
            //            }

            TypingAnimationText(string: message, count: value).frame(width: 300, alignment:  .leading)

            Button("Type") {
                withAnimation(.linear) {
                    value = message.count
                }
            }

            Button("Reset") {
                value = 0
            }
        }
    }
}

struct CreatingAnimatedViews1_Previews: PreviewProvider {
    static var previews: some View {
        CreatingAnimatedViews1()
    }
}
