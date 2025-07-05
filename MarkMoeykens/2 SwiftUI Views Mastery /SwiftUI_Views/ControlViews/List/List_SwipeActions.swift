//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct List_SwipeActions: View {
    @State private var items = [ToDoItem(task: "Get milk", done: false),
                                ToDoItem(task: "Wash car", done: true),
                                ToDoItem(task: "Cut grass", done: false)]
    
    var body: some View {
        VStack(spacing: 20.0) {
            HeaderView("List",
                       subtitle: "SwipeActions",
                       desc: "Use swipeActions to expose additional functionality on repeated items in a List.")
            List {
                ForEach($items) { $item in
                    Text(item.task)
                        .strikethrough(item.done)
                        .swipeActions {
                            Button {
                                item.done.toggle()
                            } label: {
                                Image(systemName: item.done ? "arrow.uturn.backward.square" : "checkmark.square")
                            }
                            .tint(item.done ? .blue : .green)
                    }
                }
            }
        }
        .font(.title)
    }
}

struct List_SwipeActions_Previews: PreviewProvider {
    static var previews: some View {
        List_SwipeActions()
            .preferredColorScheme(.dark)
    }
}
