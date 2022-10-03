//
//  AnimalsContainer.swift
//  PetSave
//
//  Created by Lai, Tom on 10/3/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation
struct AnimalsContainer: Decodable {
  let animals: [Animal]
  let pagination: Pagination
}
