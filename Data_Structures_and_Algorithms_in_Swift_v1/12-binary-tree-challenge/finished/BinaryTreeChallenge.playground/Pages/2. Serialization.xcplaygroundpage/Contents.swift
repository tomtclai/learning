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

// 2. Serialization

extension BinaryNode {
  
  public func traversePreOrder(visit: (Element?) -> Void) {
    visit(value)
    if let leftChild = leftChild {
      leftChild.traversePreOrder(visit: visit)
    } else {
      visit(nil)
    }
    if let rightChild = rightChild {
      rightChild.traversePreOrder(visit: visit)
    } else {
      visit(nil)
    }
  }
}

func serialize<T>(_ node: BinaryNode<T>) -> [T?] {
  var array: [T?] = []
  node.traversePreOrder { array.append($0) }
  return array
}

func deserialize<T>(_ array: [T?]) -> BinaryNode<T>? {
  var reversed = Array(array.reversed())
  return deserialize(&reversed)
}

func deserialize<T>(_ array: inout [T?]) -> BinaryNode<T>? {
  guard let value = array.removeLast() else {
    return nil
  }
  let node = BinaryNode(value: value)
  node.leftChild = deserialize(&array)
  node.rightChild = deserialize(&array)
  return node
}

let array = serialize(tree)
let node = deserialize(array)
print(node!)
