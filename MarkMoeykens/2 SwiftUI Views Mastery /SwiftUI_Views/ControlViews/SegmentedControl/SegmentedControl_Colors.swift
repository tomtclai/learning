//  Created by Mark Moeykens on 7/18/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.
//

import SwiftUI

struct SegmentedControl_Colors: View {
    @State private var selection = 2
    
    var body: some View {
        VStack(spacing: 60) {
            Picker("", selection: $selection) {
                Text("One").tag(1)
                Text("Two").tag(2)
                Text("Three").tag(3)
            }
            .pickerStyle(.segmented)
            .background(Color.pink)
            
            Picker("", selection: $selection) {
                Text("One").tag(1)
                Text("Two").tag(2)
                Text("Three").tag(3)
            }
            .pickerStyle(.segmented)
            .background(Color.pink, in: RoundedRectangle(cornerRadius: 8))
            
            Picker("", selection: $selection) {
                Text("One").tag(1)
                Text("Two").tag(2)
                Text("Three").tag(3)
            }
            .pickerStyle(.segmented)
            .background(Color.accentColor.opacity(0.6), in: RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal)
    }
}

struct SegmentedControl_Colors_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControl_Colors()
    }
}
