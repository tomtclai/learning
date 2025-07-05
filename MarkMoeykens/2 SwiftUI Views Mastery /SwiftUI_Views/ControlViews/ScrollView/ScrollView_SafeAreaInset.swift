// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct ScrollView_SafeAreaInset: View {
    @State private var names = ["Scott", "Mark", "Chris", "Sean", "Rod", "Meng", "Natasha", "Chase", "Evans", "Paul", "Durtschi", "Max"]
    var body: some View {
        ScrollView {
            ForEach(names, id: \.self) { name in
                HStack {
                    Text(name)
                        .foregroundStyle(.primary)
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                    Spacer()
                }
                .padding()
                .background(Color.white.shadow(.drop(radius: 1, y: 1)),
                            in: RoundedRectangle(cornerRadius: 8))
            }
            .padding(.horizontal)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 20) {
                Divider()
                Text("12 People")
            }
            .background(.regularMaterial)
        }
        .font(.title)
    }
}

struct ScrollView_SafeAreaInset_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView_SafeAreaInset()
    }
}
