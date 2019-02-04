import Foundation

public struct LinkedList<Value> {
    public var head: Node<Value>?
    public var tail: Node<Value>?
    
    public init() {}
    public var isEmpty: Bool {
        return head == nil
    }
    
    // Push at the head
    public mutating func push(_ value: Value) {
        copyNodes()
        let newNode = Node(value: value, next: head)
        head = newNode
        if tail == nil { tail = head }
    }
    
    // Append at the end
    public mutating func append(_ value: Value) {
        copyNodes()
        guard !isEmpty else {
            // on an empty array appending is same as push
            push(value)
            return
        }
        let newNode = Node(value: value)
        tail?.next = newNode
        
        tail = newNode
    }
    
    
    public func node(at index: Int) -> Node<Value>? {
        var current = head
        var currentIndex = 0
        
        while current != nil && currentIndex < index {
            current = current?.next
            currentIndex += 1
        }
        
        return current
    }
    
    @discardableResult
    public mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
        copyNodes()
        guard tail !== node else {
            append(value)
            return tail!
        }
        
        node.next = Node(value: value, next: node.next)
        
        return node.next!
    }
    
    @discardableResult
    public mutating func pop() -> Value? {
        copyNodes()
        let value = head?.value
        head = head?.next
        if isEmpty {
            tail = nil
        }
        return value
    }
    
    @discardableResult
    public mutating func removeLast() -> Value? {
        copyNodes()
        // empty list
        guard let head = head else { return nil }
        // 1 item list
        guard head.next != nil else { return pop() }
        // many items (need to traverse list)
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
    
    
    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        copyNodes()
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        guard let head = head else { return "Empty List" }
        return String(describing: head)
    }
}


extension LinkedList: Collection {
    public struct Index: Comparable {
        public var node: Node<Value>?
        static public func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }
        
        static public func <(lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else { return false }
            let nodes = sequence(first: lhs.node, next: { $0?.next })
            return nodes.contains { $0 === rhs.node }
        }
    }
    
    public var startIndex: Index {
        return Index(node: head)
    }
    
    public var endIndex: Index {
        // the collection defines endIndex as the index right ater the last accessible value, here it is tail?.next
        return Index(node: tail?.next)
    }
    
    public func index(after i: Index) -> Index {
        return Index(node: i.node?.next)
    }
    
    public subscript(position: Index) -> Value {
        return position.node!.value
    }
    
    
    private mutating func copyNodes() {
        return
        guard !isKnownUniquelyReferenced(&head) else { return }
        guard var oldNode = head else {
            return
        }
        
        head = Node(value: oldNode.value)
        
        var newNode = head
        
        while let nextOldNode = oldNode.next {
            newNode!.next = Node(value: nextOldNode.value)
            newNode = newNode!.next
            oldNode = nextOldNode
        }
        
        tail = newNode
    }
    
}
