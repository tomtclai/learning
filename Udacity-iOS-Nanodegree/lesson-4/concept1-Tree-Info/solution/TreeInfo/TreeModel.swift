//
//  TreeModel.swift
//  TreeInfo
//
//  Created by Mark DiFranco on 2024-05-08.
//

import SwiftUI

struct TreeModel: Identifiable {
    let name: String
    let family: String
    let description: String
    let image: ImageResource

    var id: String { name }
}

extension TreeModel {
    static let all: [TreeModel] = [
        .palmTree,
        .pineTree,
        .redwood
    ]
}

extension TreeModel {
    static let palmTree = TreeModel(
        name: "Palm Tree",
        family: "Arecaceae",
        description: "Palms are among the best known and most extensively cultivated plant families. They have been important to humans throughout much of history, especially in regions like the Middle East and North Africa. A wide range of common products and foods are derived from palms. In contemporary times, palms are also widely used in landscaping. In many historical cultures, because of their importance as food, palms were symbols for such ideas as victory, peace, and fertility.",
        image: .palmTree
    )

    static let pineTree = TreeModel(
        name: "Pine Tree",
        family: "Pinaceae",
        description: "Pine trees are evergreen, coniferous resinous trees (or, rarely, shrubs) growing 3–80 metres (10–260 feet) tall, with the majority of species reaching 15–45 m (50–150 ft) tall. The smallest are Siberian dwarf pine and Potosi pinyon, and the tallest is an 81.8 m (268 ft) tall ponderosa pine located in southern Oregon's Rogue River-Siskiyou National Forest.",
        image: .pineTree
    )

    static let redwood = TreeModel(
        name: "Redwood",
        family: "Sequoioideae",
        description: "The three redwood subfamily genera are Sequoia from coastal California and Oregon, Sequoiadendron from California's Sierra Nevada, and Metasequoia in China. The redwood species contains the largest and tallest trees in the world. These trees can live for thousands of years.",
        image: .redwood
    )
}
