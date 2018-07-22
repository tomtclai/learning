// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

extension Sequence where Element: Hashable {
  
  var firstDuplicate: Element? {
    var found: Set<Element> = []
    for value in self {
      if found.contains(value) {
        return value
      } else {
        found.insert(value)
      }
    }
    return nil
  }
}

let array = [2, 4, 5, 5, 2]
array.firstDuplicate
