// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

public class Node<Value> {
    public var value: Value
    public var next: Node?

    public init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}


extension Node: CustomStringConvertible {
    public var description: String {
        guard let next = next else {
            return "\(value)"
        }
        return "\(value) -> " + next.description
    }
}

public struct LinkedList<Value> {
    public var head: Node<Value>?
    public var tail: Node<Value>?

    public init() {}

    public var isEmpty: Bool { return head == nil }

    public var description: String {
        guard let head = head else {
            return "Empty List"
        }
        return String(describing: head)
    }

    mutating func push(_ value: Value) {
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        }
    }
    mutating func append(_ value: Value) {
        guard !isEmpty else {
            push(value)
            return
        }

        let newTail = Node(value: value, next: nil)
        tail?.next = newTail
        tail? = newTail
    }
    @discardableResult
    public mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
        guard tail !== node else {
            append(value)
            return tail!
        }

        let next = Node(value: value, next: node.next)
        node.next = next
        return next
    }

    public func node(at index: Int) -> Node<Value>? {
        var currentNode = head
        var currentIndex = 0

        while currentNode != nil && currentIndex < index {
            currentNode = currentNode!.next
            currentIndex += 1
        }

        return currentNode
    }
}


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
