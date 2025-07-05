// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct ShareLink_Customize: View {
    @State private var photo = Image("profile")
    
    var body: some View {
        VStack(spacing: 50.0) {
            ShareLink(item: "Hello and welcome!")
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
            
            ShareLink(item: photo,
                      preview: SharePreview("Share Profile Image",
                                            image: photo)) {
                photo
            }
            .shadow(radius: 8)
            
            Spacer()
        }
    }
}

struct ShareLink_Customize_Previews: PreviewProvider {
    static var previews: some View {
        ShareLink_Customize()
    }
}
