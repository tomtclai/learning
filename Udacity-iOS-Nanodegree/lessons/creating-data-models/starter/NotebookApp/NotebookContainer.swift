//
//  NotebookContainer.swift
//  NotebookApp
//
//  Created by Jesus Guerra on 5/6/24.
//

import Foundation
import SwiftData

class NotebookContainer {
    // Create the static function 'create' that returns a ModelContainer
    static func create() -> ModelContainer {
        // Define the schema for the model container using the Note class
        let schema = Schema([Note.self])
        // Define the configuration for the model container
        let config = ModelConfiguration()
        // Return the ModelContainer instance
        return try! ModelContainer(for: schema, configurations: config)

    }
}
