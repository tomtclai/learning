import Foundation
import SwiftUI

/**
 * This file acts as a mock database for temporary data storage, providing CRUD functionality.
 * It is essential to remove this file before the final project submission.
 */

@Observable
final class XStorage {
  enum Error: LocalizedError {
    case ingredientExists
    case categoryExists
    case recipeExists

    var errorDescription: String? {
      switch self {
      case .ingredientExists:
        return "Ingredient with the same name exists"
      case .categoryExists:
        return "Category with the same name exists"
      case .recipeExists:
        return "Recipe with the same name exists"
      }
    }
  }

  init() {}

  private(set) var ingredients: [MockIngredient] = []
  private(set) var categories: [MockCategory] = []
  private(set) var recipes: [MockRecipe] = []

  // MARK: - Load

  func load() {
    let pizzaDough = MockIngredient(name: "Pizza Dough")
    let tomatoSauce = MockIngredient(name: "Tomato Sauce")
    let mozzarellaCheese = MockIngredient(name: "Mozzarella Cheese")
    let freshBasilLeaves = MockIngredient(name: "Fresh Basil Leaves")
    let extraVirginOliveOil = MockIngredient(name: "Extra Virgin Olive Oil")
    let salt = MockIngredient(name: "Salt")
    let chickpeas = MockIngredient(name: "Chickpeas")
    let tahini = MockIngredient(name: "Tahini")
    let lemonJuice = MockIngredient(name: "Lemon Juice")
    let garlic = MockIngredient(name: "Garlic")
    let cumin = MockIngredient(name: "Cumin")
    let water = MockIngredient(name: "Water")
    let paprika = MockIngredient(name: "Paprika")
    let parsley = MockIngredient(name: "Parsley")
    let spaghetti = MockIngredient(name: "Spaghetti")
    let eggs = MockIngredient(name: "Eggs")
    let parmesanCheese = MockIngredient(name: "Parmesan Cheese")
    let pancetta = MockIngredient(name: "Pancetta")
    let blackPepper = MockIngredient(name: "Black Pepper")
    let driedChickpeas = MockIngredient(name: "Dried Chickpeas")
    let onions = MockIngredient(name: "Onions")
    let cilantro = MockIngredient(name: "Cilantro")
    let coriander = MockIngredient(name: "Coriander")
    let bakingPowder = MockIngredient(name: "Baking Powder")
    let chickenThighs = MockIngredient(name: "Chicken Thighs")
    let yogurt = MockIngredient(name: "Yogurt")
    let cardamom = MockIngredient(name: "Cardamom")
    let cinnamon = MockIngredient(name: "Cinnamon")
    let turmeric = MockIngredient(name: "Turmeric")

    ingredients = [
      pizzaDough,
      tomatoSauce,
      mozzarellaCheese,
      freshBasilLeaves,
      extraVirginOliveOil,
      salt,
      chickpeas,
      tahini,
      lemonJuice,
      garlic,
      cumin,
      water,
      paprika,
      parsley,
      spaghetti,
      eggs,
      parmesanCheese,
      pancetta,
      blackPepper,
      driedChickpeas,
      onions,
      cilantro,
      coriander,
      bakingPowder,
      chickenThighs,
      yogurt,
      cardamom,
      cinnamon,
      turmeric,
    ]

    var italian = MockCategory(name: "Italian")
    var middleEastern = MockCategory(name: "Middle Eastern")

    let margherita = MockRecipe(
      name: "Classic Margherita Pizza",
      summary: "A simple yet delicious pizza with tomato, mozzarella, basil, and olive oil.",
      category: italian,
      serving: 4,
      time: 50,
      ingredients: [
        MockRecipeIngredient(ingredient: pizzaDough, quantity: "1 ball"),
        MockRecipeIngredient(ingredient: tomatoSauce, quantity: "1/2 cup"),
        MockRecipeIngredient(ingredient: mozzarellaCheese, quantity: "1 cup, shredded"),
        MockRecipeIngredient(ingredient: freshBasilLeaves, quantity: "A handful"),
        MockRecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoons"),
        MockRecipeIngredient(ingredient: salt, quantity: "Pinch"),
      ],
      instructions: "Preheat oven, roll out dough, apply sauce, add cheese and basil, bake for 20 minutes.",
      imageData: UIImage(named: "margherita")?.pngData()
    )

    let spaghettiCarbonara = MockRecipe(
      name: "Spaghetti Carbonara",
      summary: "A classic Italian pasta dish made with eggs, cheese, pancetta, and pepper.",
      category: italian,
      serving: 4,
      time: 30,
      ingredients: [
        MockRecipeIngredient(ingredient: spaghetti, quantity: "400g"),
        MockRecipeIngredient(ingredient: eggs, quantity: "4"),
        MockRecipeIngredient(ingredient: parmesanCheese, quantity: "1 cup, grated"),
        MockRecipeIngredient(ingredient: pancetta, quantity: "200g, diced"),
        MockRecipeIngredient(ingredient: blackPepper, quantity: "To taste"),
      ],
      instructions: "Cook spaghetti. Fry pancetta until crisp. Whisk eggs and Parmesan, add to pasta with pancetta, and season with black pepper.",
      imageData: UIImage(named: "spaghettiCarbonara")?.pngData()
    )

    let hummus = MockRecipe(
      name: "Classic Hummus",
      summary: "A creamy and flavorful Middle Eastern dip made from chickpeas, tahini, and spices.",
      category: middleEastern,
      serving: 6,
      time: 10,
      ingredients: [
        MockRecipeIngredient(ingredient: chickpeas, quantity: "1 can (15 oz)"),
        MockRecipeIngredient(ingredient: tahini, quantity: "1/4 cup"),
        MockRecipeIngredient(ingredient: lemonJuice, quantity: "3 tablespoons"),
        MockRecipeIngredient(ingredient: garlic, quantity: "1 clove, minced"),
        MockRecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoons"),
        MockRecipeIngredient(ingredient: cumin, quantity: "1/2 teaspoon"),
        MockRecipeIngredient(ingredient: salt, quantity: "To taste"),
        MockRecipeIngredient(ingredient: water, quantity: "2-3 tablespoons"),
        MockRecipeIngredient(ingredient: paprika, quantity: "For garnish"),
        MockRecipeIngredient(ingredient: parsley, quantity: "For garnish"),
      ],
      instructions: "Blend chickpeas, tahini, lemon juice, garlic, and spices. Adjust consistency with water. Garnish with olive oil, paprika, and parsley.",
      imageData: UIImage(named: "hummus")?.pngData()
    )

    let falafel = MockRecipe(
      name: "Classic Falafel",
      summary: "A traditional Middle Eastern dish of spiced, fried chickpea balls, often served in pita bread.",
      category: middleEastern,
      serving: 4,
      time: 60,
      ingredients: [
        MockRecipeIngredient(ingredient: driedChickpeas, quantity: "1 cup"),
        MockRecipeIngredient(ingredient: onions, quantity: "1 medium, chopped"),
        MockRecipeIngredient(ingredient: garlic, quantity: "3 cloves, minced"),
        MockRecipeIngredient(ingredient: cilantro, quantity: "1/2 cup, chopped"),
        MockRecipeIngredient(ingredient: parsley, quantity: "1/2 cup, chopped"),
        MockRecipeIngredient(ingredient: cumin, quantity: "1 tsp"),
        MockRecipeIngredient(ingredient: coriander, quantity: "1 tsp"),
        MockRecipeIngredient(ingredient: salt, quantity: "1 tsp"),
        MockRecipeIngredient(ingredient: bakingPowder, quantity: "1/2 tsp"),
      ],
      instructions: "Soak chickpeas overnight. Blend with onions, garlic, herbs, and spices. Form into balls, add baking powder, and fry until golden.",
      imageData: UIImage(named: "falafel")?.pngData()
    )

    let shawarma = MockRecipe(
      name: "Chicken Shawarma",
      summary: "A popular Middle Eastern dish featuring marinated chicken, slow-roasted to perfection.",
      category: middleEastern,
      serving: 4,
      time: 120,
      ingredients: [
        MockRecipeIngredient(ingredient: chickenThighs, quantity: "1 kg, boneless"),
        MockRecipeIngredient(ingredient: yogurt, quantity: "1 cup"),
        MockRecipeIngredient(ingredient: garlic, quantity: "3 cloves, minced"),
        MockRecipeIngredient(ingredient: lemonJuice, quantity: "3 tablespoons"),
        MockRecipeIngredient(ingredient: cumin, quantity: "1 tsp"),
        MockRecipeIngredient(ingredient: coriander, quantity: "1 tsp"),
        MockRecipeIngredient(ingredient: cardamom, quantity: "1/2 tsp"),
        MockRecipeIngredient(ingredient: cinnamon, quantity: "1/2 tsp"),
        MockRecipeIngredient(ingredient: turmeric, quantity: "1/2 tsp"),
        MockRecipeIngredient(ingredient: salt, quantity: "To taste"),
        MockRecipeIngredient(ingredient: blackPepper, quantity: "To taste"),
        MockRecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoons"),
      ],
      instructions: "Marinate chicken with yogurt, spices, garlic, lemon juice, and olive oil. Roast until cooked. Serve with pita and sauces.",
      imageData: UIImage(named: "chickenShawarma")?.pngData()
    )
    
    italian.recipes = [
      margherita,
      spaghettiCarbonara,
    ]
    middleEastern.recipes = [
      hummus,
      falafel,
      shawarma,
    ]

    categories = [
      italian,
      middleEastern,
    ]

    recipes = [
      margherita,
      spaghettiCarbonara,
      hummus,
      falafel,
      shawarma,
    ]
  }

  // MARK: - Categories

  func addCategory(name: String) throws {
    guard categories.contains(where: { $0.name == name }) == false else {
      throw Error.categoryExists
    }
    categories.append(MockCategory(name: name))
  }

  func deleteCategory(id: MockCategory.ID) {
    categories.removeAll(where: { $0.id == id })
    for (index, recipe) in recipes.enumerated() where recipe.category?.id == id {
      recipes[index].category = nil
    }
  }

  func updateCategory(id: MockCategory.ID, name: String) throws {
    guard categories.contains(where: { $0.name == name && $0.id != id }) == false else {
      throw Error.categoryExists
    }
    guard let index = categories.firstIndex(where: { $0.id == id }) else {
      return
    }
    categories[index].name = name
    for (index, recipe) in recipes.enumerated() where recipe.category?.id == id {
      recipes[index].category?.name = name
    }
  }

  // MARK: - Ingredients

  func addIngredient(name: String) throws {
    guard ingredients.contains(where: { $0.name == name }) == false else {
      throw Error.ingredientExists
    }
    ingredients.append(MockIngredient(name: name))
  }

  func deleteIngredient(id: MockIngredient.ID) {
    ingredients.removeAll(where: { $0.id == id })
  }

  func updateIngredient(id: MockIngredient.ID, name: String) throws {
    guard ingredients.contains(where: { $0.name == name && $0.id != id }) == false else {
      throw Error.ingredientExists
    }
    guard let index = ingredients.firstIndex(where: { $0.id == id }) else {
      return
    }
    ingredients[index].name = name
  }

  // MARK: - Recipes

  func addRecipe(
    name: String,
    summary: String,
    category: MockCategory?,
    serving: Int,
    time: Int,
    ingredients: [MockRecipeIngredient],
    instructions: String,
    imageData: Data?
  ) throws {
    guard recipes.contains(where: { $0.name == name }) == false else {
      throw Error.recipeExists
    }
    let recipe = MockRecipe(
      name: name,
      summary: summary,
      category: category,
      serving: serving,
      time: time,
      ingredients: ingredients,
      instructions: instructions,
      imageData: imageData
    )
    recipes.append(recipe)
    if let category, let index = categories.firstIndex(where: { $0.id == category.id }) {
      categories[index].recipes.append(recipe)
    }
  }

  func deleteRecipe(id: MockRecipe.ID) {
    recipes.removeAll(where: { $0.id == id })
    for cIndex in categories.indices {
      categories[cIndex].recipes.removeAll(where: { $0.id == id })
    }
  }

  func updateRecipe(
    id: MockRecipe.ID,
    name: String,
    summary: String,
    category: MockCategory?,
    serving: Int,
    time: Int,
    ingredients: [MockRecipeIngredient],
    instructions: String,
    imageData: Data?
  ) throws {
    guard recipes.contains(where: { $0.name == name && $0.id != id }) == false else {
      throw Error.recipeExists
    }
    guard let index = recipes.firstIndex(where: { $0.id == id }) else {
      return
    }
    let recipe = MockRecipe(
      id: id,
      name: name,
      summary: summary,
      category: category,
      serving: serving,
      time: time,
      ingredients: ingredients,
      instructions: instructions,
      imageData: imageData
    )
    recipes[index] = recipe
    for cIndex in categories.indices {
      categories[cIndex].recipes.removeAll(where: { $0.id == id })
    }
    if let cIndex = categories.firstIndex(where: { $0.id == category?.id }) {
      categories[cIndex].recipes.append(recipe)
    }
  }
}

struct StorageKey: EnvironmentKey {
  static let defaultValue = Storage()
}

extension EnvironmentValues {
  var storage: Storage {
    get { self[StorageKey.self] }
    set { self[StorageKey.self] = newValue }
  }
}
