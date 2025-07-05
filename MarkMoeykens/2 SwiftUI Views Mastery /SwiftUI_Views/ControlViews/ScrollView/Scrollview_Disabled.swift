// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Scrollview_Disabled: View {
    @State private var disableScroll = false
    
    var items = [Color.green, Color.blue, Color.purple, Color.pink,
                 Color.yellow, Color.orange]
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            ForEach(items, id: \.self) { item in
                RoundedRectangle(cornerRadius: 15)
                    .fill(item)
                    .frame(height: 200)
                    .padding(.horizontal)
            }
        }
        .scrollDisabled(disableScroll)
        .safeAreaInset(edge: .bottom) {
            Toggle("Disable Scrolling", isOn: $disableScroll)
                .padding()
                .background(.regularMaterial)
        }
        .font(.title)
    }
}

struct Scrollview_Disabled_Previews: PreviewProvider {
    static var previews: some View {
        Scrollview_Disabled()
    }
}
