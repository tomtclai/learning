

import SwiftUI

struct AnimalHeaderView: View {
  var body: some View {
    Text("TODO: Animal Header View")
  }
}

struct AnimalImage: View {
  let animalPicture: URL?
  @Binding var zoomed: Bool
  let geometry: GeometryProxy

  var body: some View {
    AsyncImage(url: animalPicture) { image in
      image
        .resizable()
        .aspectRatio(zoomed ? nil : 1, contentMode: zoomed ? .fit : .fill)
    } placeholder: {
      Image("rw-logo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .overlay {
          if animalPicture != nil {
            ProgressView()
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(.gray.opacity(0.4))
          }
        }
    }
    .clipShape(
      RoundedRectangle(cornerRadius: zoomed ? 0 : 300)
    )
    .frame(
      width: zoomed ? geometry.frame(in: .local).width : 100,
      height: zoomed ? geometry.frame(in: .global).midX : 100
    )
    .position(
      x: zoomed ? geometry.frame(in: .local).midX : 50,
      y: zoomed ? geometry.frame(in: .global).midX : 50
    )
    .scaleEffect((zoomed ? 5 : 3) / 3)
    .shadow(radius: zoomed ? 10 : 1)
    .animation(.spring(), value: zoomed)
  }
}

struct HeaderTitle: View {
  var body: some View {
    Text("TODO: Header Title")
  }
}

struct HeaderTitle_Previews: PreviewProvider {
  static var previews: some View {
    HeaderTitle()
  }
}

struct AnimalHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    AnimalHeaderView()
  }
}
