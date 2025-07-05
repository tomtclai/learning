//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct AppStorage_AlternativeInits: View {
    @AppStorage(wrappedValue: false, "darkBackground") var darkBackground
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("AppStorage",
                       subtitle: "Alternative Inits",
                       desc: "AppStorage has other inits that might be less misleading.")
            
            Text("AppStorage")
        }
        .font(.title)
    }
}

struct AppStorage_AlternativeInits_Previews: PreviewProvider {
    static var previews: some View {
        AppStorage_AlternativeInits()
    }
}
