//  Created by Mark Moeykens on 6/30/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Form_RowBackgroundImage : View {
    var body: some View {
        Form {
            Section {
                Text("Images can be on a row or a section.")
                Text("Image on one row.")
                    .listRowBackground(Image("water")
                        .blur(radius: 3))
            } header: {
                Text("Images on Rows")
            }
            
            Section {
                Text("Row 1.")
                Text("Row 2.")
                Text("Row 3.")
            } header: {
                Text("Images")
            }
            .listRowBackground(Image("water")
                .blur(radius: 3))
        }
        .font(.title2)
    }
}

struct Form_RowBackgroundImage_Previews : PreviewProvider {
    static var previews: some View {
        Form_RowBackgroundImage()
    }
}
