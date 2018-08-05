example(of: "Linking notes") {
    let node1 = Node(value: 1)
    let node2 = Node(value: 2)
    let node3 = Node(value: 3)

    node1.next = node2
    node2.next = node3

    node1
}

example(of: "Push") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)
    print(list)
}

example(of: "Append") {
    var list = LinkedList<Int>()
    list.append(1)
    list.append(2)
    list.append(3)
    print(list)
}

example(of: "Inserting at an index") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)

    print("Before inserting \(list)")

    guard var middleNode = list.node(at: 1) else {
        print("item does not exist")
        return
    }

    for _ in 1...4 {
        middleNode = list.insert(-1, after: middleNode)
    }
    print("After Inserting \(list)")
}

example(of: "Pop") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)

    print("Before popping \(list)")

    let popped = list.pop()

    print("After popping \(String(describing: popped)): \(list)")
}

example(of: "Removing the last node") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)

    print("Before removing the last node \(list)")

    let removed = list.removeLast()

    print("After removing \(removed): \(list)")
}

example(of: "Removing the node after") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)

    print("Before removing the node after \(list)")

    let removed = list.remove(after: list.head!)

    print("After removing \(removed): \(list)")
}
