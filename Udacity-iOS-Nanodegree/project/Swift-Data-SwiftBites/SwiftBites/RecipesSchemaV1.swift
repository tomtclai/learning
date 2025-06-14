//
//  RecipesSchemaV1.swift
//  SwiftBites
//
//  Created by Tom Lai on 5/30/25.
//

import Foundation
import SwiftData
enum RecipesSchemaV1: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [Recipe.self]
    }
    
    static var versionIdentifier: Schema.Version = .init(1, 1, 1)
}


extension RecipesSchemaV1 {
    @Model
    final class Recipe: Identifiable, Hashable {
        var id: UUID = UUID()
        var name: String
        var summary: String
        var category: Category?
        var serving: Int
        var time: Int
        @Relationship var ingredients: [RecipeIngredient]
        var instructions: String
        var imageData: Data?
        
        init(
          name: String = "",
          summary: String = "",
          category: Category? = nil,
          serving: Int = 1,
          time: Int = 5,
          ingredients: [RecipeIngredient] = [],
          instructions: String = "",
          imageData: Data? = nil
        ) {
          self.name = name
          self.summary = summary
          self.category = category
          self.serving = serving
          self.time = time
          self.ingredients = ingredients
          self.instructions = instructions
          self.imageData = imageData
        }
    }
    
    @Model
    final class Category: Identifiable, Hashable {
        var id: UUID = UUID()
        var name: String
        @Relationship(deleteRule: .nullify) var recipes: [Recipe]

        init(name: String = "", recipes: [Recipe] = []) {
          self.name = name
          self.recipes = recipes
        }
      }
    
    @Model final class RecipeIngredient: Identifiable, Hashable {
        var id: UUID = UUID()
        @Relationship(deleteRule: .nullify, inverse: \Recipe.ingredients) var recipe = [Recipe]()
        var ingredient: Ingredient?
        var quantity: String

        init(ingredient: Ingredient = Ingredient(), quantity: String = "") {
          self.ingredient = ingredient
          self.quantity = quantity
        }
      }
    
    @Model final class Ingredient: Identifiable, Hashable {
        var id: UUID = UUID()
        var name: String
        @Relationship(deleteRule: .cascade, inverse: \RecipeIngredient.ingredient) public var recipeIngredients = [RecipeIngredient]()

        init(name: String = "") {
          self.name = name
        }
      }
}
