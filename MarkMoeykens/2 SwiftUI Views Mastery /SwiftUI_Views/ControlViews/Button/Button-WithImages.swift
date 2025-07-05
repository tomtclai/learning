//  Created by Mark Moeykens on 9/1/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Button_WithPhotos: View {
    var body: some View {
        VStack(spacing: 100) {
            Button(action: {}) {
                Image("yosemite")
            }
            
            Button(action: {}) {
                Image("yosemite")
                    .renderingMode(.original)
                    .clipShape(Capsule())
            }
            
            Button(action: {}) {
                Image("yosemite")
                    .renderingMode(.template)
                    .clipShape(Capsule())
            }
        }
        .font(.title)
    }
}

struct Button_BitmapImages_Previews: PreviewProvider {
    static var previews: some View {
        Button_WithPhotos()
    }
}
