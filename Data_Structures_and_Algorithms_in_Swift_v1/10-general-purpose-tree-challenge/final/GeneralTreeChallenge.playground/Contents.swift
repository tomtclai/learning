// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

let tree = TreeNode(15)

let one = TreeNode(1)
let seventeen = TreeNode(17)
let twenty = TreeNode(20)

tree.add(one)
tree.add(seventeen)
tree.add(twenty)

let one2 = TreeNode(1)
let five = TreeNode(5)
let zero = TreeNode(0)
let two = TreeNode(2)
let five2 = TreeNode(5)
let seven = TreeNode(7)

one.add(one2)
one.add(five)
one.add(zero)

seventeen.add(two)

twenty.add(five2)
twenty.add(seven)

func printEachLevel<T>(for tree: TreeNode<T>) {
  var queue = Queue<TreeNode<T>>()
  var nodesLeftInCurrentLevel = 0
  
  queue.enqueue(tree)
  while !queue.isEmpty {
    nodesLeftInCurrentLevel = queue.count
    while nodesLeftInCurrentLevel > 0 {
      guard let node = queue.dequeue() else { break }
      print("\(node.value) ", terminator: "")
      node.children.forEach { queue.enqueue($0) }
      nodesLeftInCurrentLevel -= 1
    }
    print()
  }
}

printEachLevel(for: tree)
