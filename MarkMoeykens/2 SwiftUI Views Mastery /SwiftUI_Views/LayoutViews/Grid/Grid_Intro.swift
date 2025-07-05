// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
/*
 The grid evenly divides up spacing for all items in all of the rows so all views in all rows have the same same widths.
 */
struct Grid_Intro: View {
    var body: some View {
        Grid {
            GridRow {
                Text("Column 1")
                Color.blue
                    .opacity(0.5)
                    .overlay(Text("Column 2"))
                    .frame(height: 50)
            }
            GridRow {
                Text("Column 1")
                /* This views stays within the width of column 1 */
            }
            GridRow {
                Text("Column 1")
                Image(systemName: "arrow.left")
                /*
                 Notice how the arrow is evenly centered within column 2.
                 */
            }
        }
        .font(.title)
    }
}

struct Grid_Intro_Previews: PreviewProvider {
    static var previews: some View {
        Grid_Intro()
    }
}
