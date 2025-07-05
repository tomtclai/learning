// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct List_SafeAreaInset_ScrollView: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderView("ScrollView",
                       subtitle: "SafeAreaInset",
                       desc: "SafeAreaInset works well with the ScrollView.")
            ScrollView {
                ForEach(1..<21) { number in
                    Text("\(number)")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.green, in: RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal)
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Divider()
                    Text("Total: 20")
                        .foregroundStyle(.secondary)
                }
                .background(.bar)
            }
        }
        .font(.title)
    }
}

struct List_SafeAreaInset_ScrollView_Previews: PreviewProvider {
    static var previews: some View {
        List_SafeAreaInset_ScrollView()
            .preferredColorScheme(.dark)
    }
}
