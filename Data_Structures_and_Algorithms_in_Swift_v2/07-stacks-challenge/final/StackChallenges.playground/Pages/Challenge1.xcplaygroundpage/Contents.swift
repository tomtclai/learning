// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.
/*:
 # Stack Challenges
 
 ## Challenge 1
 Print a linked list in reverse without using recursion. Given a linked list,
 print the nodes in reverse order. You should not use recursion to solve
 this problem.
 */

let list: LinkedList<Int> = {
  var list = LinkedList<Int>()
  list.push(3)
  list.push(2)
  list.push(1)
  return list
}()

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

//: [Next Challenge](@next)
