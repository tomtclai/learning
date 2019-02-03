// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

/*:
 ## Trie Challenge
 
 The current implementation of the trie is missing some notable operations. Your task for this challenge is to augment the current implementation of the trie by adding the following:
 
 1. A `collections` property that returns all the collections in the trie.
 
 2. A `count` property that tells you how many collections are currently in the trie.
 
 3. A `isEmpty` property that returns `true` if the trie is empty, `false` otherwise.
 
 Add code to the **Trie.swift** file in the Sources folder.
 
 */

example(of: "collections") {
  let trie = Trie<String>()
  trie.insert("car")
  trie.insert("card")
  trie.insert("care")
  trie.insert("cared")
  trie.insert("cars")
  trie.insert("carbs")
  trie.insert("carapace")
  trie.insert("cargo")
  
  trie.collections.sorted() == ["car", "carapace", "carbs", "card",
                                "care", "cared", "cargo", "cars"]  
  trie.count == 8
  trie.isEmpty == false
}
