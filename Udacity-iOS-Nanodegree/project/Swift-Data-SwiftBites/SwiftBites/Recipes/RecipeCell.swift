import SwiftUI

struct RecipeCell: View {
  let recipe: MockRecipe

  // MARK: - Body

  var body: some View {
    NavigationLink(value: RecipeForm.Mode.edit(recipe)) {
      content
    }
    .buttonStyle(.plain)
  }

  // MARK: - Views

  private var content: some View {
    VStack(alignment: .leading, spacing: 10) {
      backgroundImage
      labels
    }
    .padding(.horizontal)
  }

  private var labels: some View {
    VStack(alignment: .leading, spacing: 5) {
      Text(recipe.name)
        .font(.headline)
      Text(recipe.summary)
        .font(.subheadline)
      HStack(alignment: .center, spacing: 5) {
        if let category = recipe.category {
          tag(title: category.name, icon: "tag")
        }
        tag(title: "\(recipe.time)m", icon: "clock")
        tag(title: "\(recipe.serving)p", icon: "person")
      }
      .padding(.top, 10)
      .padding(.bottom, 20)
    }
  }

  private var backgroundImage: some View {
    innerImage
      .resizable()
      .scaledToFill()
      .frame(maxHeight: 150)
      .clipShape(RoundedRectangle(cornerRadius: 10.0))
  }

  private var innerImage: Image {
    if let data = recipe.imageData, let uiImage = UIImage(data: data) {
      Image(uiImage: uiImage)
    } else {
      Image("recipePlaceholder")
    }
  }

  // MARK: - Helpers

  private func tag(title: String, icon: String) -> some View {
    Label(title, systemImage: icon)
      .font(.caption2)
      .bold()
      .padding(.vertical, 5)
      .padding(.horizontal, 10)
      .background(Color.accent.opacity(0.1))
      .foregroundStyle(.accent)
      .clipShape(Capsule())
  }
}
