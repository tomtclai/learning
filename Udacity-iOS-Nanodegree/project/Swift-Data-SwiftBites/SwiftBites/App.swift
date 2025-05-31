import SwiftUI

typealias Recipe = RecipesSchemaV1.Recipe
typealias Category = RecipesSchemaV1.Category
typealias RecipeIngredient = RecipesSchemaV1.RecipeIngredient
typealias Ingredient = RecipesSchemaV1.Ingredient


@main
struct SwiftBitesApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .modelContainer(SwiftBitesContainer.create())
    }
  }
}
