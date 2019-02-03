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
