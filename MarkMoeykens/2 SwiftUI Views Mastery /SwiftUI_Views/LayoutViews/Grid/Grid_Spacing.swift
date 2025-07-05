// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Grid_Spacing: View {
    var body: some View {
        Grid(horizontalSpacing: 24, verticalSpacing: 24) {
            GridRow {
                Color.green.opacity(0.5)
                Color.green.opacity(0.5)
                Color.green.opacity(0.5)
            }
            GridRow {
                Color.blue.opacity(0.5)
                Color.orange.opacity(0.5)
                Color.red.opacity(0.5)
            }
            GridRow {
                Color.blue.opacity(0.5)
                Color.orange.opacity(0.5)
                Color.red.opacity(0.5)
            }
            GridRow {
                Color.blue.opacity(0.5)
                Color.orange.opacity(0.5)
                Color.red.opacity(0.5)
            }
        }
    }
}

struct Grid_Spacing_Previews: PreviewProvider {
    static var previews: some View {
        Grid_Spacing()
    }
}
