// Copyright (c) 2017 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import Foundation

// 1. How many **leaf** nodes are there in a perfectly balanced tree of height 3? What about a perfectly balanced tree of height `h`?

func leafNodes(inTreeOfHeight height: Int) -> Int {
  return Int(pow(2.0, Double(height)))
}

leafNodes(inTreeOfHeight: 2)
