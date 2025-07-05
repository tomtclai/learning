// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct List_Refreshable: View {
    @State private var stringArray = ["Evans", "Lemuel", "Mark", "Durtschi",
                                      "Chase", "Adam", "Rodrigo",]
    
    var body: some View {
        List {
            HStack {
                Text(Image(systemName: "arrow.down")) +
                Text(" Pull to Refresh ") +
                Text(Image(systemName: "arrow.down"))
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(.green)
            
            ForEach(stringArray, id: \.self) { string in
                Text(string)
            }
        }
        .font(.title)
        .refreshable {
            // Perform some action
            stringArray.append("👉 New Name")
        }
    }
}

struct List_Refreshable_Previews: PreviewProvider {
    static var previews: some View {
        List_Refreshable()
            .preferredColorScheme(.dark)
    }
}
