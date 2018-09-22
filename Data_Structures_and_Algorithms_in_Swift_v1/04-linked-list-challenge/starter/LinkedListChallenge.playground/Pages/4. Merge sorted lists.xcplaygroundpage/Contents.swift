//: [Previous](@previous)

/*:
 # Challenge 4:
 ## Create a function that takes 2 sorted linked lists and merges them into a single sorted linked list.
 */

// ascending
// https://docs.google.com/document/d/1CT99avP0nAFW_kUKjY8_u6tsbkvPb9mZtt70xSS8zTI/edit



func mergeSorted<T: Comparable>(_ left: LinkedList<T>,
                                _ right: LinkedList<T>) -> LinkedList<T> {

  let leftHead = left.head
  let rightHead = right.head


  var leftCurrent = leftHead
  var rightCurrent = rightHead

  var resultList = LinkedList<T>()

  while leftCurrent != nil || rightCurrent != nil {
    if let leftCurrent = leftCurrent,
      let rightCurrent = rightCurrent {
      // leftHead and RightHead both exists
      //    smaller goes first (ascending)
      let value = min(leftCurrent.value, rightCurrent.value)
      resultList.push(Node<T>(value: value))
    } else if let leftCurrent = leftCurrent {
      // rightHead is nil
      //    use left
      resultList.push(Node<T>(value: leftCurrent))
    } else if let rightCurrent = rightCurrnet {
      // leftHead is nil
      //    use right
      resultList.push(Node<T>(value: rightCurrent))
    } else {
      return resultList
    }
  }
  return resultList
}
