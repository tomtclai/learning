//
//  CircleImage.swift
//  SwiftUI Tutorial
//
//  Created by Tom Lai on 2019-06-11.
//  Copyright © 2019 Tom Lai. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("turtlerock")
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.gray, lineWidth: 4))
        .shadow(radius: 20)
    }
}

struct CircleImage_Preview: PreviewProvider {
    typealias Previews = CircleImage
    static var previews: Previews {
        return CircleImage()
    }
}
