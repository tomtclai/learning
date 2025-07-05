// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct ToggleTint: View {
    @State private var isLockAssistOn = false
    
    var body: some View {
        Toggle(isOn: $isLockAssistOn) {
            Image(systemName: "lock.square")
                .font(.largeTitle)
                .foregroundStyle(.red)
                .symbolVariant(isLockAssistOn ? .fill : .none)
        }
        .tint(.clear)
        .toggleStyle(.button)
    }
}

struct ToggleTint_Previews: PreviewProvider {
    static var previews: some View {
        ToggleTint()
            .previewLayout(.sizeThatFits)
    }
}
