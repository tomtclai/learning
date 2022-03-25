//
//  ContentView.swift
//  Thinking In Swift UI
//
//  Created by Lai, Tom on 3/24/22.
//

import SwiftUI

struct LabelView: View {
    @State var counter = 0
    var body: some View {
        print("LabelView")
        return VStack {
            Button("Tap") {
                self.counter += 1

            }
            if counter > 0 {
                Text("You tapped \(counter) times")
            }
        }
    }
}
struct ContentView: View {

    var body: some View {
        ForEach(1...10, id:\.self) { x in
            Text("Item \(x)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
