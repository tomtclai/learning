// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct OnChange_Intro: View {
    @State private var name = "Rabbit"
    @State private var icon = "hare.fill"
    @State private var color = Color.brown
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("onChange", subtitle: "Introduction",
                       desc: "Allows you to run some code when a value changes.",
                       back: .blue, textColor: .white)
            
            Button("Change Animal") {
                if name == "Rabbit" {
                    name = "Turtle"
                } else {
                    name = "Rabbit"
                }
            }
            
            Label(name, systemImage: icon)
                .padding()
                .background(color, in: RoundedRectangle(cornerRadius: 8))
        }
        .font(.title)
        .onChange(of: name) { oldValue, newValue in
            if newValue == "Turtle" {
                icon = "tortoise.fill"
                color = Color.green
            } else {
                icon = "hare.fill"
                color = Color.brown
            }
        }
    }
}

struct OnChange_Intro_Previews: PreviewProvider {
    static var previews: some View {
        OnChange_Intro()
    }
}
