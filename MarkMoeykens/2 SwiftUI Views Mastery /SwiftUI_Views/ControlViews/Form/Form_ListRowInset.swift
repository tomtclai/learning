//  Created by Mark Moeykens on 6/30/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Form_ListRowInset : View {
    var body: some View {
        Form {
            Section {
                Text("List Row Inset")
                    .foregroundStyle(.gray)
                Text("You can use the listRowInsets modifier to adjust the indentation:")
                    .foregroundStyle(.white)
                    .listRowBackground(Color.purple)
                
                Text("Indent Level 1")
                    .listRowInsets(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
                
                Text("Indent Level 2")
                    .listRowInsets(EdgeInsets(top: 0, leading: 80, bottom: 0, trailing: 0))
                
                Text("Or Vertical Alignment")
                    .foregroundStyle(.white)
                    .listRowBackground(Color.purple)
                
                Text("Top")
                    .listRowInsets(EdgeInsets(top: -20, leading: 40, bottom: 0, trailing: 0))
                
                Text("Bottom")
                    .listRowInsets(EdgeInsets(top: 20, leading: 40, bottom: 0, trailing: 0))
            } header: {
                Text("Form")
                    .font(.title)
                    .foregroundStyle(.gray)
            }
        }
        .font(.title2)
    }
}

struct Form_ListRowInset_Previews : PreviewProvider {
    static var previews: some View {
        Form_ListRowInset()
    }
}
