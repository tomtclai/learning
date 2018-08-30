// Copyright (c) 2017 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

example(of: "repeated insertions in sequence") {
  var tree = AVLTree<Int>()
  for i in 0..<15 {
    tree.insert(i)
  }
  print(tree)
}

// 3. Create a `TraversableBinaryNode` and have `AVLNode` conform to it.

