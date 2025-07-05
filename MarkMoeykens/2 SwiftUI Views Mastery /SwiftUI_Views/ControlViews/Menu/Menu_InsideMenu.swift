//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Menu_InsideMenu: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Menu("Edit") {
                Button("Add color", systemImage: "eyedropper.full") { }
                Button("Change contrast", systemImage: "circle.lefthalf.fill") { }
                
                Menu("More...") {
                    Button("Magic Wand", systemImage: "wand.and.stars") { }
                    Button("Magic Paint", systemImage: "paintbrush.fill") { }
                }
            }
            
            Spacer()
        }
        .font(.title)
    }
}

struct Menu_InsideMenu_Previews: PreviewProvider {
    static var previews: some View {
        Menu_InsideMenu()
    }
}
