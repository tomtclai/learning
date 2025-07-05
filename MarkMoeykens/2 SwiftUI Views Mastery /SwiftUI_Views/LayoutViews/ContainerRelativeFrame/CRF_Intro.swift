// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
/* iOS 17
 * Ignores padding and safe areas
 */
struct CRF_Intro: View {
    var body: some View {
        VStack(spacing: 24.0) {
            Text("Frame MaxWidth")
                .frame(maxWidth: .infinity)
                .border(.red)
            Text("ContainerRelativeFrame")
                .containerRelativeFrame(.horizontal)
                .border(.green)
            
            HStack {
                Text("Frame")
                    .frame(maxHeight: .infinity)
                    .border(.red)
                Text("CRF")
                    .containerRelativeFrame(.vertical, alignment: .top)
                    .border(.green)
            }
        }
        .font(.title)
        .padding(45)
    }
}

#Preview {
    CRF_Intro()
}
