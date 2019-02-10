// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

let stack = Stack<Int>()
stack


example(of: "stack") {
    var stack = Stack<Int>()
    stack.push(1)
    stack.push(2)
    stack.push(3)
    stack.push(4)
    
    print(stack)
    
    if let poppedElement = stack.pop() {
        assert(4 == poppedElement)
        print("Popped: \(poppedElement)")
    }
    
    print(stack)
}


example(of: "initialize") {
    let array = ["A", "B", "C", "D"]
    var stack = Stack(array)
    print(stack)
    stack.pop()
    print(stack)
}
