import SwiftUI

extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}

struct ContentView: View {
    @State var active: Bool = true
    var body: some View {
        Circle()
            .opacity( active ? 1 : 0.5)
            .animation(Animation.easeInOut.repeat(while: active))
            .frame(width: 100, height: 100)
            .onTapGesture {
                self.active.toggle()
            }
    }
}

struct TheSolution_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
