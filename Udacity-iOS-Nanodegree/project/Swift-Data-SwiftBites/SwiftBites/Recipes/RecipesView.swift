import SwiftUI
import SwiftData
struct RecipesView: View {
  @State private var query = ""
  @State private var sortOrder = SortDescriptor(\Recipe.name)
    @Query private var recipes: [Recipe]

  // MARK: - Body

  var body: some View {
    NavigationStack {
      content
        .navigationTitle("Recipes")
        .toolbar {
          if !recipes.isEmpty {
            sortOptions
            ToolbarItem(placement: .topBarTrailing) {
              NavigationLink(value: RecipeForm.Mode.add) {
                Label("Add", systemImage: "plus")
              }
            }
          }
        }
        .navigationDestination(for: RecipeForm.Mode.self) { mode in
          RecipeForm(mode: mode)
        }
    }
  }

  // MARK: - Views

  @ToolbarContentBuilder
  var sortOptions: some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Menu("Sort", systemImage: "arrow.up.arrow.down") {
        Picker("Sort", selection: $sortOrder) {
          Text("Name")
            .tag(SortDescriptor(\Recipe.name))

          Text("Serving (low to high)")
            .tag(SortDescriptor(\Recipe.serving, order: .forward))

          Text("Serving (high to low)")
            .tag(SortDescriptor(\Recipe.serving, order: .reverse))

          Text("Time (short to long)")
            .tag(SortDescriptor(\Recipe.time, order: .forward))

          Text("Time (long to short)")
            .tag(SortDescriptor(\Recipe.time, order: .reverse))
        }
      }
      .pickerStyle(.inline)
    }
  }

  @ViewBuilder
  private var content: some View {
    if recipes.isEmpty {
      empty
    } else {
      list(for: recipes.filter {
        if query.isEmpty {
          return true
        } else {
          return $0.name.localizedStandardContains(query) || $0.summary.localizedStandardContains(query)
        }
      }.sorted(using: sortOrder))
    }
  }

  var empty: some View {
    ContentUnavailableView(
      label: {
        Label("No Recipes", systemImage: "list.clipboard")
      },
      description: {
        Text("Recipes you add will appear here.")
      },
      actions: {
        NavigationLink("Add Recipe", value: RecipeForm.Mode.add)
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
      }
    )
  }

  private var noResults: some View {
    ContentUnavailableView(
      label: {
        Text("Couldn't find \"\(query)\"")
      }
    )
  }

  private func list(for recipes: [Recipe]) -> some View {
    ScrollView(.vertical) {
      if recipes.isEmpty {
        noResults
      } else {
        LazyVStack(spacing: 10) {
          ForEach(recipes, content: RecipeCell.init)
        }
      }
    }
    .searchable(text: $query)
  }
}
