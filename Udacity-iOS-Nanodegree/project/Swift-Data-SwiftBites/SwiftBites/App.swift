import SwiftUI

typealias Recipe = RecipesSchemaV1.Recipe

@main
struct SwiftBitesApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .modelContainer(SwiftBitesContainer.create())
    }
  }
}
