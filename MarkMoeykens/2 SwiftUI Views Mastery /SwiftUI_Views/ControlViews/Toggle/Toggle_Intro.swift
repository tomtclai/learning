//  Created by Mark Moeykens on 6/28/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Toggle_Intro : View {
    @State private var isToggleOn = true
    
    var body: some View {
        VStack(spacing: 10) {
            HeaderView("Toggle",
                       subtitle: "Introduction",
                       desc: "The Toggle is a 'push-out view' that only pushes out to fill the width of its parent view.")
            
            Toggle("Night Mode", isOn: $isToggleOn)
                .padding()
            
            DescView(desc: "Combine images with text")
            
            Toggle(isOn: $isToggleOn) {
                Label("Night Mode", systemImage: "moon")
            }
            .padding()
            
            DescView(desc: "Or you can have nothing")
            
            VStack {
                Text("Turn Alarm On?")
                    .foregroundStyle(.white)
                Toggle("Turn this alarm on", isOn: $isToggleOn)
                    .labelsHidden() // Hides the label/title
            }
            .padding(25)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .font(.title)
    }
}

struct Toggle_Intro_Previews : PreviewProvider {
    static var previews: some View {
        Toggle_Intro()
    }
}
