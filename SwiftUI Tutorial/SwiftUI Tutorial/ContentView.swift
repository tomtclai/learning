// see https://developer.apple.com/tutorials/swiftui/creating-and-combining-views#customize-the-text-view

import SwiftUI

struct ContentView : View {
    var body: some View {
        CircleImage()
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
