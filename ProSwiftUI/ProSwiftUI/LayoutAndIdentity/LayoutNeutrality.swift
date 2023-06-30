//
//  LayoutNeutrality.swift
//  ProSwiftUI
//
//  Created by Paul Hudson on 03/09/2022.
//

import SwiftUI

struct LayoutNeutrality: SelfCreatingView {
    @State private var usesFixedSize = false

    var body: some View {

        VStack {
            ScrollView {
                Color.red
                    .frame(minWidth: nil, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: 400, maxHeight: 400)
            }
//            Text("Hello, World!")
//                .frame(width: usesFixedSize ? 300 : nil)
//                .background(.red)
//
//            Toggle("Fixed sizes", isOn: $usesFixedSize.animation())
        }
    }
}

struct LayoutNeutrality_Previews: PreviewProvider {
    static var previews: some View {
        LayoutNeutrality()
    }
}
