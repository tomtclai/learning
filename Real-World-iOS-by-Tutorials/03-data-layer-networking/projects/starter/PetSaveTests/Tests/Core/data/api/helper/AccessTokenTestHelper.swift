//
//  AccessTokenTestHelper.swift
//  PetSaveTests
//
//  Created by tom on 10/16/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation
@testable import PetSave

enum AccessTokenTestHelper {
  static func randomString() -> String {
    let scalars = [UnicodeScalar("a").value...UnicodeScalar("z").value].joined()
    let characters = scalars.map { Character(UnicodeScalar($0)!) }

    return String(characters.shuffled().prefix(8))
  }
}
