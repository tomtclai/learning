// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

/*:
 # Challenge 1:
 ## Create a function that prints out the elements of a Linked List in reverse order.
 */

func printInReverse<T>(_ list: LinkedList<T>) {
  func helper(node: Node<T>?) {
    // if i am nil
    //    return
    guard let node = node else { return }
    // otherwise
    //    make recursive call on the next item
    //    print my value
    helper(node: node.next)
    print(node.value)
  }

  helper(node: list.head)
}

example(of: "Challenge 1") {
  var list = LinkedList<Int>()
  list.push(3)
  list.push(2)
  list.push(1)

  print("\(list)")

  printInReverse(list)
}

//: [Next](@next)
