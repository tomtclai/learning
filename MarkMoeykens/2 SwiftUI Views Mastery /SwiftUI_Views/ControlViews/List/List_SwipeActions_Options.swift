//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct List_SwipeActions_Options: View {
    var body: some View {
        VStack(spacing: 20.0) {
            HeaderView("List",
                       subtitle: "SwipeActions - Options",
                       desc: "You can specify which side to swipe with the edge parameter and if you want a full swipe.")
                .layoutPriority(1)
            List {
                ForEach(0 ..< 3) { item in
                    Text("Item \(item)")
                    // Book Note: swipeActions only seem to work on the outer-most view
                        .swipeActions(allowsFullSwipe: false) {
                            Button {  } label: {
                                Image(systemName: "xmark")
                            }
                            .tint(.red)
                            Button { } label: {
                                Image(systemName: "checkmark.square")
                            }
                            .tint(.green)
                        }
                }
            }
            List {
                ForEach(3 ..< 6) { item in
                    Text("Item \(item)")
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button { } label: {
                                Image(systemName: "flag")
                            }
                            .tint(.purple)
                        }
                }
            }
        }
        .font(.title)
    }
}

struct List_SwipeActions_Options_Previews: PreviewProvider {
    static var previews: some View {
        List_SwipeActions_Options()
            .preferredColorScheme(.dark)
    }
}
