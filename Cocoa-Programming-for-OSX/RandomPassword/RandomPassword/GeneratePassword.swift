//
//  GeneratePassword.swift
//  RandomPassword
//
//  Created by Tom Lai on 7/30/15.
//  Copyright (c) 2015 Tom. All rights reserved.
//

import Foundation

private let characters = Array("0123456789abcdefghijklmnopqrstuvwxyz" +
                               "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

/// returns a randomly generated string of the requested length
func generateRandomString(length: Int) -> String {
    // Start with an empty string
    var string = ""

    // Append 'length' number or random characters
    for index in 0..<length {
        string.append(generateRandomCharacter())
    }

    return string
}

/// returns a randomly-chosen character from the characters array
func generateRandomCharacter() -> Character {
    // Create a random index into the characters array
    let index = Int(arc4random_uniform(UInt32(characters.count)))

    // Get and return a random character
    let character = characters[index]
    return character
}
