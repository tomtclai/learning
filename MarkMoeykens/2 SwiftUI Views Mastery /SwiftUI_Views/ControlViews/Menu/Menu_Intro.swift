//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI
/*
 HeaderView("Menu",
 subtitle: "Introduction",
 desc: "Use the Menu view to group up similar actions to present to the user from a tappable button.",
 back: .blue, textColor: .white)
 
 */
struct Menu_Intro: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Menu("Edit") {
                // iOS 15
                ControlGroup {
                    Button("Add color", systemImage: "eyedropper.full") { }
                    Button("Change Contrast", systemImage: "circle.lefthalf.fill") { }
                }

                Button("Erase", systemImage: "eraser.fill") { }
                Button("Scribble Tool", systemImage: "scribble.variable") { }
            }
            
            Spacer()
        }
        .font(.title)
    }
}

struct Menu_Intro_Previews: PreviewProvider {
    static var previews: some View {
        Menu_Intro()
    }
}
