// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct List_Selection_Single: View {
    @State private var data = ["Practice Coding", "Grocery shopping", "Get tickets", "Clean house", "Do laundry", "Cook dinner", "Paint room"]
    @State private var selection: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List(data, id: \.self, selection: $selection) { item in
                    Text(item)
                        .fontWeight(selection == item ? .bold : .regular)
                        .foregroundStyle(selection == item ? .green : .primary)
                        .padding(selection == item ? 8 : 0)
                }
                Text("To do first: ") +
                Text(selection ?? "")
                    .bold()
            }
            .font(.title)
            .navigationTitle("List")
        }
    }
}

struct List_Selection_Single_Previews: PreviewProvider {
    static var previews: some View {
        List_Selection_Single()
    }
}
