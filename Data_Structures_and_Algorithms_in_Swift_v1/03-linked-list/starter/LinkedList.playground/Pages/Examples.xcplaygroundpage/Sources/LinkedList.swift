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

    public mutating func push(_ value: Value) {
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        }
    }
    public mutating func append(_ value: Value) {
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

    @discardableResult
    public mutating func pop() -> Value? {
        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }

    @discardableResult
    public mutating func removeLast() -> Value? {
        guard let head = head else { return nil }
        guard head.next != nil else { return pop() }
        var prev = head
        var current = head
        while let next = current.next {
            prev = current
            current = next
        }

        prev.next = nil
        tail = prev

        return current.value
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

    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
}

extension LinkedList: Collection {
    public struct Index: Comparable {
        public var node: Node<Value>?

        static public func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next

            case (nil, nil): return true

            default: return false
            }
        }

        static public func <(lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else { return false }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains { $0 === rhs.node }
        }
    }
    public var startIndex: Index {
        return Index(node: head)
    }

    public var endIndex: Index {
        return Index(node: tail?.next)
    }

    public func index(after i: Index) -> Index {
        return Index(node: i.node?.next)
    }

    public subscript(position: Index) -> Value {
        return position.node!.value
    }
}

