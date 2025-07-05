// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct FB_FocusStateCrash: View {
    enum NameFields {
        case firstName
        case lastName
    }
    
    // Jan 19, 22 - Uncommenting @FocusState generates a problem report when trying to preview.
    //@FocusState private var nameFields: NameFields?
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct FB_FocusStateCrash_Previews: PreviewProvider {
    static var previews: some View {
        FB_FocusStateCrash()
    }
}
