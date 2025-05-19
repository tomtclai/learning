//
//  NotebookContainer.swift
//  NotebookApp
//
//  Created by Jesus Guerra on 5/6/24.
//

import Foundation
import SwiftData

class NotebookContainer {
    static func create() -> ModelContainer{
        let schema = Schema([Note.self])
        let configuration = ModelConfiguration()
        return try! ModelContainer(for: schema, configurations: configuration)
    }
}
