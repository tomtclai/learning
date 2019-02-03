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
