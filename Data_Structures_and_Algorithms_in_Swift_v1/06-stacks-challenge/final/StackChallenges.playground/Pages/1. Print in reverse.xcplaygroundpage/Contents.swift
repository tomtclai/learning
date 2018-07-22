// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

let list: LinkedList<Int> = {
  var list = LinkedList<Int>()
  list.push(3)
  list.push(2)
  list.push(1)
  return list
}()

/*: 1. Create a function that takes a linked list and prints it in reverse. You may not use recursion. */

func printInReverse<T>(_ list: LinkedList<T>) {
  var current = list.head
  var stack = Stack<T>()
  
  while let node = current {
    stack.push(node.value)
    current = node.next
  }
  
  while let value = stack.pop() {
    print(value)
  }
}

printInReverse(list)

