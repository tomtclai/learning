//
//  InsideTupleView1.swift
//  ProSwiftUI
//
//  Created by Paul Hudson on 03/09/2022.
//

import SwiftUI
//extension ViewBuilder {
//    static func buildPartialBlock<Content>(first content: Content) -> Content where Content: View {
//        content
//    }
//    
//    static func buildPartialBlock<C0, C1>(accumulated: C0, next: C1) -> TupleView<(C0, C1)> where C0: View, C1: View {
//        TupleView((accumulated, next))
//    }
//}
struct InsideTupleView1: SelfCreatingView {
    var body: some View {
        VStack {
            Text("Hello")
            Text("Hello")
            Text("World")
        }
        .onTapGesture {
            print(type(of: self.body))
        }
    }
}

struct InsideTupleView1_Previews: PreviewProvider {
    static var previews: some View {
        InsideTupleView1()
    }
}
