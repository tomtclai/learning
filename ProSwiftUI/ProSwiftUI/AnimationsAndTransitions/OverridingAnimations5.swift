//
//  OverridingAnimations5.swift
//  ProSwiftUI
//
//  Created by Paul Hudson on 03/09/2022.
//

import SwiftUI

extension OverridingAnimations5 {
    struct CircleGrid: View {
        var useRedFill = false
        
        var body: some View {
            ScrollView{
                LazyVGrid(columns: [.init(.adaptive(minimum: 64))]) {
                    ForEach(0..<50) { i in
                        Circle()
                            .fill(useRedFill ? .red : .blue)
                            .frame(height: 64)
                        // Each circle can examine and override the transactions
                        // Use this modifier to change or replace the animation used in a view
                            .transaction { transaction in
                                transaction.animation = transaction.animation?.delay(Double(i) / 50)
                            }
                    }
                }
            }
        }
    }
}


struct OverridingAnimations5: SelfCreatingView {
    @State var useRedFill = false

    var body: some View {
        VStack {
            CircleGrid(useRedFill: useRedFill)

            Spacer()

            Button("Toggle Color") {
                withAnimation(.easeInOut) {
                    useRedFill.toggle()
                }
            }
        }
    }
}

struct OverridingAnimations5_Previews: PreviewProvider {
    static var previews: some View {
        OverridingAnimations5()
    }
}
