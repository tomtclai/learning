// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.
/*:
 [Previous Challenge](@previous)
 ## Challenge 4:
 Create a function that takes 2 sorted linked lists and merges them into a single sorted linked list.
 */

func mergeSorted<T: Comparable>(_ left: LinkedList<T>,
                                _ right: LinkedList<T>) -> LinkedList<T> {
  
    // two runners,
    // leftCurr
    // rightCurr
    
    var leftOptionalCurr = left.head
    var rightOptionalCurr = right.head
    
    var auxList = LinkedList<T>()
    
    //
    //
    //  1 -> 3 -> 5
    //  2 -> 4 -> 6
    //
    //  curr = smaller of the leftCurr and rightCurr
    //  curr -> 4
    //
    
    
    // while neither lists are empty
    while let leftCurr = leftOptionalCurr,
        let rightCurr = rightOptionalCurr {
        if leftCurr.value < rightCurr.value {
            // left smaller
            auxList.push(leftCurr.value)
            leftOptionalCurr = leftCurr.next
        } else {
            // right smaller (or equal)
            auxList.push(rightCurr.value)
            rightOptionalCurr = rightCurr.next
        }
    }
    
    while let leftCurr = leftOptionalCurr {
        auxList.push(leftCurr.value)
        leftOptionalCurr = leftCurr.next
    }
    
    while let rightCurr = rightOptionalCurr {
        auxList.push(rightCurr.value)
        rightOptionalCurr = rightCurr.next
    }
    
    
 
    
    //  4 -> 3 -> 2 -> 1 (backwards)
    //
    
    
    //  Need to reverse:
    //
    
    var resultList = LinkedList<T>()
    //  while not empty
    //  resultList.push(backwardlist.pop())
    //
    while let auxHead = auxList.pop() {
        resultList.push(auxHead)
    }
  return resultList
}


var leftList = LinkedList<Int>()
leftList.push(5)
leftList.push(3)
leftList.push(1)
leftList.push(0)

var rightList = LinkedList<Int>()
rightList.push(6)
rightList.push(3)
rightList.push(2)

var merged = mergeSorted(leftList, rightList)


//: [Next Challenge](@next)
