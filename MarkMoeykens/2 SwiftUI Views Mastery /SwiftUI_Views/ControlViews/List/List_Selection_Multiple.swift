// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct List_Selection_Multiple: View {
    @State private var data = ["Practice Coding", "Grocery shopping", "Get tickets", "Clean house", "Do laundry", "Cook dinner", "Paint room"]
    @State private var selections = Set<String>()
    
    var body: some View {
        NavigationStack {
            List(data, id: \.self, selection: $selections) { item in
                Text(item)
            }
            .font(.title)
            .navigationTitle("List")
            .toolbar { EditButton() }
        }
    }
}

struct List_Selection_Multiple_Previews: PreviewProvider {
    static var previews: some View {
        List_Selection_Multiple()
    }
}
