// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Toolbar_ContextMenu: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HeaderView("",
                           subtitle: "Showing ContextMenu",
                           desc: "You can create a context menu from a toolbar button. (Long-press to show menu.)")
                Spacer()
            }
            .navigationTitle("Toolbar")
            .font(.title)
            .toolbar {
                ToolbarItem {
                    Menu("Edit") {
                        Button(action: {}) {
                            Text("Add color")
                            Image(systemName: "eyedropper.full")
                        }
                        Button(action: {}) {
                            Image(systemName: "circle.lefthalf.fill")
                            Text("Change contrast")
                        }
                    }
//                    Button(action: {}) {
//                        Image(systemName: "line.3.horizontal.circle")
//                    }
//                    .contextMenu {
//                        Button(action: {}) {
//                            Text("Add color")
//                            Image(systemName: "eyedropper.full")
//                        }
//                        Button(action: {}) {
//                            Image(systemName: "circle.lefthalf.fill")
//                            Text("Change contrast")
//                        }
//                    }
                }
            }
            .tint(.green)
        }
    }
}

struct Toolbar_ContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        Toolbar_ContextMenu()
    }
}
