//  Created by Mark Moeykens on 9/21/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Navigation_CustomBackButton: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Go To Detail",
                           destination: Navigation_CustomBackButton_Detail())
            .font(.title)
            .navigationTitle("Navigation Views")
        }
    }
}
// Second Screen
struct Navigation_CustomBackButton_Detail: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
        }
        .navigationTitle("Detail View")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Label("Back", systemImage: "arrow.left.circle")
                }
            }
        }
    }
}

struct Navigation_CustomBackButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Navigation_CustomBackButton()
            Navigation_CustomBackButton_Detail()
        }
    }
}
