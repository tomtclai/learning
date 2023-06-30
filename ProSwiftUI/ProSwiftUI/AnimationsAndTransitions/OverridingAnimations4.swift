//
//  OverridingAnimations4.swift
//  ProSwiftUI
//
//  Created by Paul Hudson on 03/09/2022.
//

import SwiftUI

extension OverridingAnimations4 {
    func withHighPriorityAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
        var transaction = Transaction(animation: animation)
        transaction.disablesAnimations = true
        return try withTransaction(transaction, body)
    }
}

struct OverridingAnimations4: SelfCreatingView {
    @State var scale = 1.0

    var body: some View {
        Button("Tap Me") {
            // not only remove but put in a new aniamtion
            // do this instead
            withHighPriorityAnimation(.linear(duration: 0.1)) {
                scale += 1
            }
        }
        .scaleEffect(scale)
        .animation(.default, value: scale)
    }
}

struct OverridingAnimations4_Previews: PreviewProvider {
    static var previews: some View {
        OverridingAnimations4()
    }
}
