//  Created by Mark Moeykens on 6/23/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct List_Delete : View {
    @State var data = ["Swipe to Delete", "Practice Coding", "Grocery shopping", "Get tickets", "Clean house", "Do laundry", "Cook dinner", "Paint room"]
    
    var body: some View {
        List {
            Section {
                ForEach(data, id: \.self) { datum in
                    Text(datum)
                        .padding()
                        .deleteDisabled(datum == "Clean house")
                }
                .onDelete { offsets in
                    data.remove(atOffsets: offsets)
                }
            } header: {
                Text("To Do")
            }
        }
        .font(.title)
    }
}

struct List_Delete_Previews : PreviewProvider {
    static var previews: some View {
        List_Delete()
            .preferredColorScheme(.dark)
    }
}
