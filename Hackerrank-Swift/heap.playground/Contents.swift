import UIKit
struct Heap<Element> {
    var elements : [Element]
    let priorityFunction : (Element, Element) -> Bool
    
    var isEmpty : Bool {
        return elements.isEmpty
    }
    
    var count : Int {
        return elements.count
    }
    
    func peek() -> Element? {
        return elements.first
    }
    
    func isRoot(_ index: Int) -> Bool {
        return (index == 0)
    }
    
    func leftChildIndex(of index: Int) -> Int {
        return (2 * index) + 1
    }
    
    func rightChildIndex(of index: Int) -> Int {
        return (2 * index) + 2
    }
    
    func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }
    
    func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
        return priorityFunction(elements[firstIndex], elements[secondIndex])
    }
    
    func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < count else { return parentIndex }
        if isHigherPriority(at: childIndex, than: parentIndex) {
            return childIndex
        } else {
            return parentIndex
        }
    }
    
    func highestPriorityIndex(for parent: Int) -> Int {
        let leftIndex = leftChildIndex(of: parent)
        let rightIndex = rightChildIndex(of: parent)
        return highestPriorityIndex(of: highestPriorityIndex(of: parent,
                                                             and: leftIndex),
                                    and: rightIndex )
    }
    
    mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
        elements.swapAt(firstIndex, secondIndex)
    }
    
    mutating func enqueue(_ element: Element) {
        elements.append(element)
        heapifyUp(elementAtIndex: count - 1)
    }
    
    mutating func heapifyUp(elementAtIndex index: Int) {
        let parent = parentIndex(of: index)
        guard !isRoot(index),
            isHigherPriority(at: index, than: parent) else {
                return
        }
        swapElement(at: index, with: parent)
        heapifyUp(elementAtIndex: parent)
    }
    
    mutating func dequeue() -> Element? {
        guard !isEmpty
            else { return nil }
        swapElement(at: 0, with: count - 1)
        let element = elements.removeLast()
        if !isEmpty {
            heapifyDown(elementAtIndex: 0)
        }
        return element
    }
    
    mutating func heapifyDown(elementAtIndex index: Int) {
        let childIndex = highestPriorityIndex(for: index)
        if index == childIndex {
            // all done! this heap is legal
            return
        }
        swapElement(at: index, with: childIndex)
        heapifyDown(elementAtIndex: childIndex)
    }
    init(elements: [Element] = [], priorityFunction: @escaping (Element, Element) -> Bool) {
        self.elements = elements
        self.priorityFunction = priorityFunction
        buildHeap()
    }
    
    mutating func buildHeap() {
        for index in (0..<count/2).reversed() {
            heapifyDown(elementAtIndex: index)
        }
    }
}
var maxHeap = Heap(elements: [3, 2, 8, 5, 0], priorityFunction: >)
maxHeap.dequeue()

var minHeap = Heap(elements: [3, 2, 8, 5, 0], priorityFunction: <)
minHeap.dequeue()
