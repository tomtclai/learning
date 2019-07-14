//
//  ContentView.swift
//  SwiftUITest
//
//  Created by Tom Lai on 7/12/19.
//  Copyright © 2019 Tom Lai. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        parkCell()
    }
}


func parkCell() -> some View {
    return VStack(alignment: .leading) {
        Text("Turtle Rock")
            .font(.title)
            .color(.green)
        HStack {
            Text("Joshua Tree National Park")
                .font(.subheadline)
            Spacer()
            Text("California")
                .font(.subheadline)
        }
    }
    .padding()
}
#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
