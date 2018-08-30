// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

extension MutableCollection where Self: BidirectionalCollection, Element: Equatable {
  
  mutating func rightAlign(value: Element) {
    var left = startIndex
    var right = index(before: endIndex)
    
    while left < right {
      while self[right] == value {
        formIndex(before: &right)
      }
      while self[left] != value {
        formIndex(after: &left)
      }
      guard left < right else {
        return
      }
      swapAt(left, right)
    }
  }
}

var array = [3, 4, 134, 3, 5, 6, 3, 5, 6, 1, 0]

array.rightAlign(value: 3)
print(array)
