// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct TaskItem: Identifiable, Hashable {
    var id = UUID()
    var item = ""
    var complete = false
}

struct List_Selection_SingleObject: View {
    @State private var data = [
        TaskItem(item: "Practice Coding"),
        TaskItem(item: "Grocery shopping"),
        TaskItem(item: "Get tickets"),
        TaskItem(item: "Clean house"),
        TaskItem(item: "Do laundry"),
        TaskItem(item: "Cook dinner"),
        TaskItem(item: "Paint room")
    ]
    @State private var selection: TaskItem?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List(data, selection: $selection) { taskItem in
                    Text(taskItem.item)
                        .padding(selection == taskItem ? 8 : 0)
                        .tag(taskItem) // This is the key
                }
                Text("To do first: ") +
                Text(selection?.item ?? "")
                    .bold()
            }
            .font(.title)
            .navigationTitle("List")
        }
    }
}

#Preview {
    List_Selection_SingleObject()
}
