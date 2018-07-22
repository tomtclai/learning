// Copyright (c) 2017 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import Foundation

// 2. How many **nodes** are there in a perfectly balanced tree of height 3? What about a perfectly balanced tree of height `h`?

//func nodes(inTreeOfHeight height: Int) -> Int {
//  var totalHeight = 0
//  for currentHeight in 0...height {
//    totalHeight += Int(pow(2.0, Double(currentHeight)))
//  }
//  return totalHeight
//}

func nodes(inTreeOfHeight height: Int) -> Int {
  return Int(pow(2, Double(height + 1))) - 1
}

nodes(inTreeOfHeight: 2)
