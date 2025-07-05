//  Created by Mark Moeykens on 9/8/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Button_WithBorders: View {
    var body: some View {
        VStack(spacing: 60) {
            Button(action: {}) {
                Text("Square Border Button")
                    .padding()
                    .border(Color.purple, width: 2)
            }
            
            Button(action: {}) {
                Text("Border Button")
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.purple, lineWidth: 2)
                    }
            }
        }
        .font(.title)
    }
}

#Preview {
    Button_WithBorders()
}
