//
//  Created by Mark Moeykens on 6/18/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.
//

import SwiftUI

struct Picker_Customized : View {
    @State private var favoriteState = 1
    @State private var youTuberName = "Mark"
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Picker").font(.largeTitle)
            Text("With Modifiers").foregroundStyle(.gray)
            Text("Your Favorite State:")
            Picker("Select State", selection: $favoriteState) {
                Text("California").tag(0)
                Text("Utah").tag(1)
                Text("Vermont").tag(2)
            }
            .pickerStyle(.wheel)
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue))
            .padding()
            
            Text("Who do you want to watch today?")
            Picker("Select person", selection: $youTuberName) {
                Text("Paul").tag("Paul")
                Text("Chris").tag("Chris")
                Text("Mark").tag("Mark")
                Text("Scott").tag("Scott")
                Text("Meng").tag("Meng")
            }
            .pickerStyle(.wheel)
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.blue, lineWidth: 1))
            .padding()
        }
        .font(.title)
    }
}

struct Picker_Customized_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            Picker_Customized()
                .preferredColorScheme(.dark)
            Picker_Customized()
                .preferredColorScheme(.dark)
        }
    }
}
