// Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct List_SafeAreaInset: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderView("List",
                       subtitle: "SafeAreaInset",
                       desc: "You can use this modifier to overlay a view on top of another view but also offset the content of the parent view.")
            List {
                ForEach(1..<21) { number in
                    Text("\(number)")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.green, in: RoundedRectangle(cornerRadius: 10))
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Divider()
                    Text("Total: 20")
                        .foregroundStyle(.secondary)
                }
                .background(.bar)
            }
            .listStyle(.plain)
        }
        .font(.title)
    }
}

struct List_SafeAreaInset_Previews: PreviewProvider {
    static var previews: some View {
        List_SafeAreaInset()
            .preferredColorScheme(.dark)
    }
}
