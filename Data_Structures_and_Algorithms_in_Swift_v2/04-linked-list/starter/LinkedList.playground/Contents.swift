// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

example(of: "link nodes") {
    let node1 = Node(value: 1)
    let node2 = Node(value: 2)
    let node3 = Node(value: 3)
    
    node1.next = node2
    node2.next = node3
    
    print(node1)
}


example(of: "pushing nodes") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    print(list)
}


example(of: "inserting at a particular index") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    
    print("before inseting \(list)")
    var middleNode = list.node(at: 1)!
    for _ in 1...4 {
        middleNode = list.insert(-1, after: middleNode)
    }
    print("after inseting \(list)")
}


example(of: "pop") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    
    print("Before popping list")
    
    var poppedValue = list.pop()
    print(poppedValue.debugDescription)
    print(list)
    poppedValue = list.pop()
    print(poppedValue.debugDescription)
    print(list)
    poppedValue = list.pop()
    print(poppedValue.debugDescription)
    print(list)
}


example(of: "removing after") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    
    print("before removing at index 1 \(list)")
    let index = 1
    let node = list.node(at: index - 1)!
    print(node)
    
    let removedValue = list.remove(after: node)
    
    print("after removingAtIndex \(index). \(list)")
    print(removedValue.debugDescription)
}


example(of: "collection") {
    var list = LinkedList<Int>()
    for i in 0...9 {
        list.append(i)
    }
    
    print("list \(list)")
    print("first element \(list[list.startIndex])")
    print("first 3 elements \(list.prefix(3))")
    print("first 3 elements \(Array(list.prefix(3)))")
    print("last 3 elements \(list.suffix(3))")
    print("last 3 elements \(Array(list.suffix(3)))")
    
    let sum = list.reduce(0, +)
    print(sum)
}


example(of: "array cow") {
    let array1 = [1, 2]
    var array2 = array1
    print("array1 \(array1)")
    print("array2 \(array2)")
    array2.append(3)
    print("array1 \(array1)")
    print("array2 \(array2)")
}

example(of: "linkedlist cow") {
    var list1 = LinkedList<Int>()
    list1.append(1)
    list1.append(2)
    var list2 = list1
    print("list1 \(list1)")
    print("list2 \(list2)")
    list2.append(3)
    print("list1 \(list1)")
    print("list2 \(list2)")
}


example(of: "node sharing") {
    var list1 = LinkedList<Int>()
    list1.append(1)
    list1.append(2)
    list1.append(3)
    
    var list2 = list1
    list2.push(0)
    list1.push(8000)
    print("list1 \(list1)")
    print("list2 \(list2)")
}

