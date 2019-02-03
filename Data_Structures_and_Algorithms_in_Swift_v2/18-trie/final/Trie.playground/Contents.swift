// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.


// Xcode 10 Swift 4.2 Note: You may see messages
// SWIFT RUNTIME BUG: unable to demangle type ...
// This is a known ("harmless") issue in Swift 4.2
// and being tracked here:
// https://bugs.swift.org/browse/SR-8354

example(of: "insert and contains") {
  let trie = Trie<String>()
  trie.insert("cute")
  if trie.contains("cute") {
    print("cute is in the trie")
  }
}

example(of: "remove") {
  let trie = Trie<String>()
  trie.insert("cut")
  trie.insert("cute")
  
  print("\n*** Before removing ***")
  assert(trie.contains("cut"))
  print("\"cut\" is in the trie")
  assert(trie.contains("cute"))
  print("\"cute\" is in the trie")
  
  print("\n*** After removing cut ***")
  trie.remove("cut")
  assert(!trie.contains("cut"))
  assert(trie.contains("cute"))
  print("\"cute\" is still in the trie")
}

example(of: "prefix matching") {
  let trie = Trie<String>()
  trie.insert("car")
  trie.insert("card")
  trie.insert("care")
  trie.insert("cared")
  trie.insert("cars")
  trie.insert("carbs")
  trie.insert("carapace")
  trie.insert("cargo")
  
  print("\nCollections starting with \"car\"")
  let prefixedWithCar = trie.collections(startingWith: "car")
  print(prefixedWithCar)
  
  print("\nCollections starting with \"care\"")
  let prefixedWithCare = trie.collections(startingWith: "care")
  print(prefixedWithCare)
}
