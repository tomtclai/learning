// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct CUV_WithImages: View {
    var body: some View {
        VStack {
            ContentUnavailableView("With Image Asset", image: "book.logo.large")

            ContentUnavailableView("With SF Font", systemImage: "paintbrush")
            
            ContentUnavailableView {
                Label("With Label", systemImage: "paintbrush")
            }
        }
    }
}

#Preview {
    CUV_WithImages()
}
