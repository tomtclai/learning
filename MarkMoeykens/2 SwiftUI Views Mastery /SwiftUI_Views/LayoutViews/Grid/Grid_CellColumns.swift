// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Grid_CellColumns: View {
    var body: some View {
        Grid {
            GridRow {
                Color.green.opacity(0.5)
                    .gridCellColumns(3)
            }
            GridRow {
                Color.blue.opacity(0.5)
                Color.red.opacity(0.5)
                    .gridCellColumns(2)
            }
            GridRow {
                Color.blue.opacity(0.5)
                Color.orange.opacity(0.5)
                Color.red.opacity(0.5)
            }
            GridRow {
                Color.orange.opacity(0.5)
                    .gridCellColumns(2)
                Color.red.opacity(0.5)
            }
        }
    }
}

struct Grid_CellColumns_Previews: PreviewProvider {
    static var previews: some View {
        Grid_CellColumns()
    }
}
