// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct CUV_Concept: View {
    var body: some View {
        ContentUnavailableView("Title", 
                               systemImage: "paintbrush",
                               description: Text("Description (Optional)"))
    }
}

#Preview {
    CUV_Concept()
}
