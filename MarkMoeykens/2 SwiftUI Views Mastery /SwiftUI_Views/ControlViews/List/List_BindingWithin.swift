//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct ToDoItem: Identifiable {
    let id = UUID()
    var task = ""
    var priority = false
    var done = false
}

struct List_BindingWithin: View {
    @State private var items = [ToDoItem(task: "Get milk", done: false),
                                ToDoItem(task: "Wash car", done: true),
                                ToDoItem(task: "Cut grass", done: false)]
    
    var body: some View {
        VStack(spacing: 20.0) {
            HeaderView("List",
                       subtitle: "Binding Within",
                       desc: "You can now bind list data directly controls in list rows.")
            List($items) { $item in
                HStack {
                    TextField("Task", text: $item.task)
                    Toggle("Done?", isOn: $item.done)
                        .labelsHidden()
                }
            }
        }
        .font(.title)
    }
}

struct List_EditingWithin_Previews: PreviewProvider {
    static var previews: some View {
        List_BindingWithin()
    }
}
