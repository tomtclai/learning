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
        let newNode = Node(value: value, next: head)
        head = newNode
        if tail == nil { tail = head }
    }
    
    // Append at the end
    public mutating func append(_ value: Value) {
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
        guard tail !== node else {
            append(value)
            return tail!
        }
        
        node.next = Node(value: value, next: node.next)
        
        return node.next!
    }
    
    @discardableResult
    public mutating func pop() -> Value? {
        let value = head?.value
        head = head?.next
        if isEmpty {
            tail = nil
        }
        return value
    }
    
    @discardableResult
    public mutating func removeLast() -> Value? {
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
