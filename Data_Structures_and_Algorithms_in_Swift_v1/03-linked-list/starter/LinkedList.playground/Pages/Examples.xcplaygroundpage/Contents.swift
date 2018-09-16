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

example(of: "using collection") {
    var list = LinkedList<Int>()
    for i in 0...9 {
        list.append(i)
    }
    print("List \(list)")
    print("First element: \(list[list.startIndex])")
    print("Array containing first 3 elements \(Array(list.prefix(3)))")
    print("Array containing last 3 elements \(Array(list.suffix(3)))")
    print("Sum of all values \(list.reduce(0, +))")
}

// Another important quality of a swift collection is that they have value semantics. This is implemented using copy-on-write, hereby known as COW. To Illustrate this concept, you will verify this behavior using arrays. Write the following at the bottom of the playgorudn page.

example(of: "array COW") {
    let array1 = [1, 2]
    var array2 = array1

    print("array1: \(array1)")
    print("array2: \(array2)")

    print("after adding 3 to array 2")
    array2.append(3)
    print("array1: \(array1)")
    print("array2: \(array2)")
}


example(of: "linkedlist COW") {
    var array1 = LinkedList<Int>()
    array1.append(1)
    array1.append(2)
    print("List 1 uniquely referenced : \(isKnownUniquelyReferenced(&array1.head))")
    var array2 = array1
    print("List 1 uniquely referenced : \(isKnownUniquelyReferenced(&array1.head))")
    print("array1: \(array1)")
    print("array2: \(array2)")

    print("after adding 3 to array 2")
    array2.append(3)
    print("array1: \(array1)")
    print("array2: \(array2)")
}


example(of: "Challenge 1") {
    var list = LinkedList<Int>()
    list.push(3)
    list.push(2)
    list.push(1)

    print("\(list)")

    func printInReverse(list: LinkedList<Int>) {
        func helper(node: Node<Int>?) {
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

    printInReverse(list: list)
}
