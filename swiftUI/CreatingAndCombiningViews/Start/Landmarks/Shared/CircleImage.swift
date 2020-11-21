//
//  CircleImage.swift
//  Landmarks
//
//  Created by Tom Lai on 11/20/20.
//

// https://developer.apple.com/tutorials/swiftui/creating-and-combining-views
import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("turtlerock")
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
            .shadow(radius: 10)
            
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
