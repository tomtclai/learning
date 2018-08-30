// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

var tree: BinaryNode<Int> {
  let zero = BinaryNode(value: 0)
  let one = BinaryNode(value: 1)
  let five = BinaryNode(value: 5)
  let seven = BinaryNode(value: 7)
  let eight = BinaryNode(value: 8)
  let nine = BinaryNode(value: 9)
  
  seven.leftChild = one
  one.leftChild = zero
  one.rightChild = five
  seven.rightChild = nine
  nine.leftChild = eight
  
  return seven
}

print(tree)

// 1. Find the height of the binary tree.

func height<T>(of node: BinaryNode<T>?) -> Int {
  guard let node = node else {
    return -1
  }
  return 1 + max(height(of: node.leftChild), height(of: node.rightChild))
}

height(of: tree)
