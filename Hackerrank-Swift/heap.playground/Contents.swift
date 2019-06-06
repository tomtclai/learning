import UIKit

enum HeapType {
    case maxHeap
    case minHeap
}
struct Heap {
    var items: [Int] = []
    var heapType: HeapType
    init(heapType: HeapType) {
        self.heapType = heapType
    }
    private func getLeftChildIndex(_ parentIndex: Int) -> Int {
        return 2 * parentIndex + 1
    }
    
    private func getRightChildIndex(_ parentIndex: Int) -> Int {
        return 2 * parentIndex + 2
    }
    
    private func getParentIndex(_ childIndex: Int) -> Int {
        return (childIndex - 1) / 2
    }
    
    private func leftChild(_ index: Int) -> Int? {
        let lIndex = getLeftChildIndex(index)
        guard lIndex < items.count else {
            return nil
        }
        return items[lIndex]
    }
    
    private func rightChild(_ index: Int) -> Int? {
        let rIndex = getRightChildIndex(index)
        guard rIndex < items.count else {
            return nil
        }
        return items[rIndex]
    }
    
    private func parent(_ index: Int) -> Int? {
        let pIndex = getParentIndex(index)
        guard pIndex < items.count else {
            return nil
        }
        return items[pIndex]
    }
    
    public func peek() -> Int? {
        if items.count != 0 {
            return items[0]
        } else {
            return nil
        }
    }
    
    mutating public func poll() -> Int? {
        if items.count != 0 {
            let item = items[0]
            items[0] = items[items.count - 1]
            heapifyDown()
            items.removeLast()
            return item
        } else {
            return nil
        }
    }
    
    mutating public func add(_ item: Int) {
        items.append(item)
        heapifyUp()
    }
    
    mutating private func heapifyUp() {
        var index = items.count - 1
        
        while let pElement = parent(index), comparison(pElement, items[index]) {
            let pIndex = getParentIndex(index)
            items.swapAt(pIndex, index)
            index = pIndex
        }
    }
    
    
    private func comparison(_ a: Int, _ b: Int) -> Bool {
        switch heapType {
        case .minHeap:
            return a < b
        case .maxHeap:
            return a > b
        }
    }
    mutating private func heapifyDown() {
        var index = 0
        while let _ = leftChild(index) {
            var smallerChildIndex = getLeftChildIndex(index)
            if let _ = rightChild(index) {
                smallerChildIndex = getRightChildIndex(index)
            }
            if comparison(items[index], items[smallerChildIndex]) {
                break
            } else {
                items.swapAt(index, smallerChildIndex)
            }
            
            index = smallerChildIndex
        }
    }
}

var head = Heap(heapType: .minHeap)
head.items = [1,2,34,6,75,4]
head.peek()

var head2 = Heap(heapType: .maxHeap)
head2.items = [1,2,34,6,75,4]
head2.peek()
