//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Label_ListItemTint: View {
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("Label",
                       subtitle: "List Item Tint",
                       desc: "In iOS, you can apply an item tint color to a Label view to change just the image.",
                       back: .pink)
            
            List {
                Label("Edit", systemImage: "rectangle.and.pencil.and.ellipsis")
                    .listItemTint(.pink)
                Label("Archives", systemImage: "archivebox.circle")
                    .listItemTint(.orange)
                Label("Document", systemImage: "doc.richtext")
                    .listItemTint(.red)
                Label("Camera Settings", systemImage: "camera.badge.ellipsis")
                    .listItemTint(.monochrome)
            }
            
            Label("Bullet List", systemImage: "list.bullet.rectangle.fill")
                .listItemTint(.red)
        }
        .font(.title)
    }
}

struct Label_ListItemTint_Previews: PreviewProvider {
    static var previews: some View {
        Label_ListItemTint()
    }
}
