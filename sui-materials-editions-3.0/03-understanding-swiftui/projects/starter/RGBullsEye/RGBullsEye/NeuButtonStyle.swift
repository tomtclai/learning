
import SwiftUI

struct NeuButtonStyle: ButtonStyle {
  let width: CGFloat
  let height: CGFloat
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .frame(width: 327, height: 48)
      .opacity(configuration.isPressed ? 0.2: 1)
      .background(Group{
        if configuration.isPressed {
          Capsule()
                        .fill(Color.element)
        } else {
          Capsule()
                        .fill(Color.element)
                        .northWestShadow()
        }
      })
  }
}



struct NeuButtonStyle_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.element.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
      Button("hit me", action: {})
        .buttonStyle(NeuButtonStyle(width: 327, height: 48))
    }
  }
}
