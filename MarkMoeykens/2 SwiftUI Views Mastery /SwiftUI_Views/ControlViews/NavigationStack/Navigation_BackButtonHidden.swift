//  Created by Mark Moeykens on 9/21/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

// First Screen
struct Navigation_BackButtonHidden: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Go To Detail", destination: BackButtonHiddenDetail())
                .font(.title)
                .navigationTitle("Navigation Views")
        }
    }
}

// Second Screen
struct BackButtonHiddenDetail: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button("Go Back") {
            dismiss()
        }
        .font(.title)
        .navigationTitle("Detail View")
        .navigationBarBackButtonHidden(true)
    }
}


struct Navigation_BackButtonHidden_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Navigation_BackButtonHidden()
            BackButtonHiddenDetail()
        }
    }
}
