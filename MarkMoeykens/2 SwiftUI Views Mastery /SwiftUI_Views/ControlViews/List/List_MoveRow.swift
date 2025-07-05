//  Created by Mark Moeykens on 6/23/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct List_MoveRow : View {
    @State var data = ["Hit the Edit button to reorder", "Practice Coding", "Grocery shopping", "Get tickets", "Clean house", "Do laundry", "Cook dinner", "Paint room"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(data, id: \.self) { datum in
                    Text(datum).font(Font.system(size: 24)).padding()
                        .moveDisabled((datum == "Clean house"))
                }
                .onMove { source, destination in
                    data.move(fromOffsets: source, toOffset: destination)
                }
            }
            .navigationTitle("To Do")
            .toolbar {
                ToolbarItem { EditButton() }
            }
            .listStyle(.plain)
        }
        .tint(.green) // Changes color of buttons
    }
}

struct List_MoveRow_Previews : PreviewProvider {
    static var previews: some View {
        List_MoveRow()
            .preferredColorScheme(.dark)
    }
}
