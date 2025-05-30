//
//  SwiftBitesContainer.swift
//  SwiftBites
//
//  Created by Tom Lai on 5/30/25.
//
import Foundation
import SwiftData
import SwiftUI
actor SwiftBitesContainer {
    @MainActor
    static func create() -> ModelContainer {
        let schema = Schema([Recipe.self])
        let configuration = ModelConfiguration()
        
    }
    
    private static func isEmpty(context: ModelContext) -> Bool {
    }
    
    private static func sampleRecipes() -> [Recipe] {
    }
}
