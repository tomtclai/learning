// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct List_ScrollContentBackground: View {
    private var stringArray = ["Evans", "Lemuel", "Mark", "Durtschi", "Chase", "Adam", "Rodrigo"]
    @State private var show = false
    @State private var showSystemBackground: Visibility = .visible
    
    var body: some View {
        List(stringArray, id: \.self) { string in
            Text(string)
        }
        .background(Color.green.opacity(0.25))
        .scrollContentBackground(showSystemBackground)
        .safeAreaInset(edge: .bottom) {
            VStack {
                Divider()

                Button {
                    show.toggle()
                    showSystemBackground = show ? .hidden : .visible
                } label: {
                    if show {
                        Image(systemName: "eye.slash")
                    } else {
                        Image(systemName: "eye")
                            .buttonStyle(.borderedProminent)
                    }
                }
                .symbolVariant(.fill)
                .padding()
            }
            .background(.thinMaterial)
        }
        .font(.title)
    }
}

struct List_ScrollContentBackground_Previews: PreviewProvider {
    static var previews: some View {
        List_ScrollContentBackground()
    }
}
