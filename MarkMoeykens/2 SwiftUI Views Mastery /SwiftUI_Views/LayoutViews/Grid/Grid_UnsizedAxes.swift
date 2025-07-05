// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Grid_UnsizedAxes: View {
    var body: some View {
        Grid {
            GridRow {
                Color.blue.opacity(0.5)
                Color.orange.opacity(0.5)
                    .frame(width: 75)
                Color.red.opacity(0.5)
            }
            
            GridRow {
                Color.blue.opacity(0.5)
                    .gridCellUnsizedAxes(.vertical)
                Color.orange.opacity(0.5)
                    .gridCellUnsizedAxes(.vertical)
                    .gridCellUnsizedAxes(.horizontal)
                Color.red.opacity(0.5)
                    .frame(height: 150)
            }
        }
    }
}

struct Grid_UnsizedAxes_Previews: PreviewProvider {
    static var previews: some View {
        Grid_UnsizedAxes()
    }
}
