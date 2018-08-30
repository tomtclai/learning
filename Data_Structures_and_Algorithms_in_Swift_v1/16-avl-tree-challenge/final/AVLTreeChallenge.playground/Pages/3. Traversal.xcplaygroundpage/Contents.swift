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

protocol TraversableBinaryNode {
    
  associatedtype Element
  var value: Element { get }
  var leftChild: Self? { get }
  var rightChild: Self? { get }
  func traverseInOrder(visit: (Element) -> Void)
  func traversePreOrder(visit: (Element) -> Void)
  func traversePostOrder(visit: (Element) -> Void)
}

extension TraversableBinaryNode {
  
  func traverseInOrder(visit: (Element) -> Void) {
    leftChild?.traverseInOrder(visit: visit)
    visit(value)
    rightChild?.traverseInOrder(visit: visit)
  }
  
  func traversePreOrder(visit: (Element) -> Void) {
    visit(value)
    leftChild?.traversePreOrder(visit: visit)
    rightChild?.traversePreOrder(visit: visit)
  }
  
  func traversePostOrder(visit: (Element) -> Void) {
    leftChild?.traversePostOrder(visit: visit)
    rightChild?.traversePostOrder(visit: visit)
    visit(value)
  }
}

extension AVLNode: TraversableBinaryNode {}

example(of: "using TraversableBinaryNode") {
  var tree = AVLTree<Int>()
  for i in 0..<15 {
    tree.insert(i)
  }
  tree.root?.traverseInOrder { print($0) }
}
