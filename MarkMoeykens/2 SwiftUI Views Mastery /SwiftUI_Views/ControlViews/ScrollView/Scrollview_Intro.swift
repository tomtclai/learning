//  Created by Mark Moeykens on 6/23/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct Scrollview_Intro : View {
    @State private var names = ["Scott", "Mark", "Chris", "Sean", "Rod", "Meng", "Natasha", "Chase", "Evans", "Paul", "Durtschi", "Max"]
    var body: some View {
        ScrollView {
            ForEach(names, id: \.self) { name in
                HStack {
                    Text(name).foregroundStyle(.primary)
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                    Spacer()
                }
                .padding()
                .background(Color.white.shadow(.drop(radius: 1, y: 1)),
                            in: RoundedRectangle(cornerRadius: 8))
                .padding(.bottom, 4)
            }
            .padding(.horizontal)
        }
        .font(.title)
    }
}

struct Scrollview_Intro_Previews : PreviewProvider {
    static var previews: some View {
        Scrollview_Intro()
    }
}
