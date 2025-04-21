//
//  PathStore.swift
//  Navigation
//
//  Created by Tom Lai on 4/20/25.
//

import SwiftUI

class PathStore: ObservableObject {
    @Published var path = NavigationPath() {
        didSet {
            save()
        }
    }
    
    private let savePath = URL.documentsDirectory.appendingPathComponent("SavedPathStore")
    func save() {
        guard let representation = path.codable else {return}
        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Error saving path: \(error)")
        }
    }
    
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }
    }
}


