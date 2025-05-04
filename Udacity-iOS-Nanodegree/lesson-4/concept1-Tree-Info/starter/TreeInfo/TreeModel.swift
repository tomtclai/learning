//
//  TreeModel.swift
//  TreeInfo
//
//  Created by Mark DiFranco on 2024-05-08.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let red = Double((int >> 16) & 0xFF) / 255
        let green = Double((int >> 8) & 0xFF) / 255
        let blue = Double(int & 0xFF) / 255
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
    }
}

struct TreeModel: Identifiable, Hashable {
    let name: String
    let family: String
    let description: String
    let image: ImageResource
    let color: Color

    var id: String { name }
}

extension TreeModel {
    static let all: [TreeModel] = [.palmTree, .pineTree, .redwood, .oak, .maple, .birch, .spruce, .cedar, .willow, .banyan, .cherryBlossom, .elm, .ash, .beech, .mahogany, .eucalyptus, .fir, .magnolia, .cypress, .baobab, .olive, .teak, .dogwood]
}

extension TreeModel {

    static let palmTree = TreeModel(
        name: "Palm Tree",
        family: "Arecaceae",
        description: "Palms are among the best known and most extensively cultivated plant families. They have been important to humans throughout much of history, especially in regions like the Middle East and North Africa. A wide range of common products and foods are derived from palms. In contemporary times, palms are also widely used in landscaping. In many historical cultures, because of their importance as food, palms were symbols for such ideas as victory, peace, and fertility.",
        image: .palmTree,
        color: Color(hex: "2E8B57")
    )

    static let pineTree = TreeModel(
        name: "Pine Tree",
        family: "Pinaceae",
        description: "Pine trees are evergreen, coniferous resinous trees (or, rarely, shrubs) growing 3–80 metres (10–260 feet) tall, with the majority of species reaching 15–45 m (50–150 ft) tall. The smallest are Siberian dwarf pine and Potosi pinyon, and the tallest is an 81.8 m (268 ft) tall ponderosa pine located in southern Oregon's Rogue River-Siskiyou National Forest.",
        image: .pineTree,
        color: Color(hex: "2E4D2E")
    )

    static let redwood = TreeModel(
        name: "Redwood",
        family: "Sequoioideae",
        description: "The three redwood subfamily genera are Sequoia from coastal California and Oregon, Sequoiadendron from California's Sierra Nevada, and Metasequoia in China. The redwood species contains the largest and tallest trees in the world. These trees can live for thousands of years.",
        image: .redwood,
        color: Color(hex: "A0522D")
    )
    static let oak = TreeModel(
           name: "Oak",
           family: "Fagaceae",
           description: "Oaks are large hardwood trees known for their strength and longevity, producing acorns that feed wildlife.",
           image: .oak,
           color: Color(hex: "6B4F1A")
       )

       static let maple = TreeModel(
           name: "Maple",
           family: "Sapindaceae",
           description: "Maple trees are famed for their distinctive leaves and sap, which can be boiled down into maple syrup.",
           image: .maple,
           color: Color(hex: "D2691E")
       )

       static let birch = TreeModel(
           name: "Birch",
           family: "Betulaceae",
           description: "Birch trees are slender, fast-growing trees with papery bark, commonly found in northern temperate regions.",
           image: .birch,
           color: Color(hex: "EDE8D3")
       )

       static let spruce = TreeModel(
           name: "Spruce",
           family: "Pinaceae",
           description: "Spruces are evergreen conifers with needle-like leaves and conical shapes, widely used as Christmas trees.",
           image: .spruce,
           color: Color(hex: "2F4F4F")
       )

       static let cedar = TreeModel(
           name: "Cedar",
           family: "Cupressaceae",
           description: "Cedars are aromatic conifers valued for their durable, rot-resistant wood and fragrant oils.",
           image: .cedar,
           color: Color(hex: "8B4513")
       )

       static let willow = TreeModel(
           name: "Willow",
           family: "Salicaceae",
           description: "Willows have long, drooping branches and are often found near water; their bark contains salicylic acid.",
           image: .willow,
           color: Color(hex: "7CFC00")
       )

       static let banyan = TreeModel(
           name: "Banyan",
           family: "Moraceae",
           description: "Banyan trees develop aerial prop roots that become thick trunks, creating expansive canopies.",
           image: .banyan,
           color: Color(hex: "8B4513")
       )

       static let cherryBlossom = TreeModel(
           name: "Cherry Blossom",
           family: "Rosaceae",
           description: "Cherry blossoms are ornamental flowering trees celebrated for their delicate pink blooms in spring.",
           image: .cherryBlossom,
           color: Color(hex: "FFC0CB")
       )

       static let elm = TreeModel(
           name: "Elm",
           family: "Ulmaceae",
           description: "Elms are tall, vase-shaped trees prized for their graceful form and shade-providing canopy.",
           image: .elm,
           color: Color(hex: "228B22")
       )

       static let ash = TreeModel(
           name: "Ash",
           family: "Oleaceae",
           description: "Ash trees are valued for their strong, elastic wood, often used in tool handles and sports equipment.",
           image: .ash,
           color: Color(hex: "A9A9A9")
       )

       static let beech = TreeModel(
           name: "Beech",
           family: "Fagaceae",
           description: "Beech trees are smooth-barked and produce edible nuts; they form dense, shady woodlands.",
           image: .beech,
           color: Color(hex: "9DC183")
       )

       static let mahogany = TreeModel(
           name: "Mahogany",
           family: "Meliaceae",
           description: "Mahogany is a tropical hardwood prized for its rich color and resonance in fine furniture and instruments.",
           image: .mohogany,
           color: Color(hex: "C04000")
       )

       static let eucalyptus = TreeModel(
           name: "Eucalyptus",
           family: "Myrtaceae",
           description: "Eucalyptus trees are fast-growing evergreens from Australia known for their fragrant oil-rich leaves.",
           image: .eucalyptus,
           color: Color(hex: "5F9EA0")
       )

       static let fir = TreeModel(
           name: "Fir",
           family: "Pinaceae",
           description: "Firs are conical evergreen trees with soft needles, commonly used as Christmas trees and in construction.",
           image: .fir,
           color: Color(hex: "228B22")
       )

       static let magnolia = TreeModel(
           name: "Magnolia",
           family: "Magnoliaceae",
           description: "Magnolias are ancient flowering trees known for their large, fragrant blossoms in spring and summer.",
           image: .magnolia,
           color: Color(hex: "FFF8DC")
       )

       static let cypress = TreeModel(
           name: "Cypress",
           family: "Cupressaceae",
           description: "Cypresses are coniferous trees with feathery foliage, often found in wetlands and ornamental plantings.",
           image: .cypress,
           color: Color(hex: "556B2F")
       )

       static let baobab = TreeModel(
           name: "Baobab",
           family: "Malvaceae",
           description: "Baobabs are massive African trees with thick trunks that store water and produce nutrient-rich fruit.",
           image: .baobab,
           color: Color(hex: "DEB887")
       )

       static let olive = TreeModel(
           name: "Olive",
           family: "Oleaceae",
           description: "Olive trees are gnarled evergreens cultivated for their fruit and oil, central to Mediterranean culture.",
           image: .olive,
           color: Color(hex: "808000")
       )

       static let teak = TreeModel(
           name: "Teak",
           family: "Lamiaceae",
           description: "Teak is a tropical hardwood prized for its durability, water resistance, and golden hue in outdoor furniture.",
           image: .teak,
           color: Color(hex: "CD853F")
       )

       static let dogwood = TreeModel(
           name: "Dogwood",
           family: "Cornaceae",
           description: "Dogwoods are ornamental trees celebrated for their showy bracts and colorful berries in fall.",
           image: .dogwood,
           color: Color(hex: "FFB6C1")
       )
}
